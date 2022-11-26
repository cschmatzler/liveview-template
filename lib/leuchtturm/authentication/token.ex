defmodule Leuchtturm.Authentication.Token do
  alias Leuchtturm.Ecto.UUIDv6
  alias Leuchtturm.Authentication.Token

  use Ecto.Schema

  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @schema_prefix "authentication"
  @primary_key {:id, UUIDv6, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "tokens" do
    field :token, :binary
    field :purpose, :string
    field :sent_to, :string

    belongs_to :user, Leuchtturm.Authentication.User, type: :binary_id

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.

  The reason why we store session tokens in the database, even
  though Phoenix already provides a session cookie, is because
  Phoenix' default session cookies are not persisted, they are
  simply signed and potentially encrypted. This means they are
  valid indefinitely, unless you change the signing/encryption
  salt.

  Therefore, storing them allows individual user
  sessions to be expired. The token system can also be extended
  to store additional data, such as the device used for logging in.
  You could then use this information to display all valid sessions
  and devices in the UI and allow users to explicitly expire any
  session they deem invalid.
  """

  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)

    {token, %Token{token: token, purpose: "session", user_id: user.id}}
  end

  def build_email_token(user, purpose) do
    build_hashed_token(user, purpose, user.email)
  end

  defp build_hashed_token(user, purpose, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %Token{
       token: hashed_token,
       purpose: purpose,
       sent_to: sent_to,
       user_id: user.id
     }}
  end
end
