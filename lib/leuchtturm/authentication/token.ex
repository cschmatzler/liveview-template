defmodule Leuchtturm.Authentication.Token do
  alias Leuchtturm.Authentication.{Token, User}

  use Ecto.Schema

  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @schema_prefix "authentication"
  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "tokens" do
    field :token, :binary
    field :purpose, :string
    field :sent_to, :string

    belongs_to :user, Leuchtturm.Authentication.User, type: :binary_id

    timestamps(updated_at: false)
  end

  @type t :: %Token{
          id: UUID.t() | nil,
          token: binary(),
          purpose: String.t(),
          sent_to: String.t() | nil,
          user: User.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: DateTime.t() | nil
        }

  @spec user_from_session_token_query(binary()) :: Ecto.Query.t()
  def user_from_session_token_query(token) do
    from token in token_and_purpose_query(token, "session"),
      join: user in assoc(token, :user),
      where: token.inserted_at > ago(@session_validity_in_days, "day"),
      select: user
  end

  @spec token_and_purpose_query(binary(), String.t()) :: Ecto.Query.t()
  def token_and_purpose_query(token, purpose) do
    from Token, where: [token: ^token, purpose: ^purpose]
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  @spec build_session_token(binary()) :: Token.t()
  def build_session_token(user_id) do
    token = :crypto.strong_rand_bytes(@rand_size)

    %Token{token: token, purpose: "session", user_id: user_id}
  end

  @spec build_email_token(User.t(), String.t()) :: {binary(), Token.t()}
  def build_email_token(user, purpose) do
    build_hashed_token(user, purpose, user.email)
  end

  @spec build_hashed_token(User.t(), String.t(), String.t()) :: {binary(), Token.t()}
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
