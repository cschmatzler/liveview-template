defmodule Leuchtturm.Auth.Token do
  use Ecto.Schema

  import Ecto.Query
  alias Leuchtturm.Auth.User

  @rand_size 32
  @session_validity_in_days 7

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "tokens" do
    field :token, :binary
    belongs_to :user, Leuchtturm.Auth.User
    timestamps(updated_at: false)
  end

  @type t :: %__MODULE__{
          id: integer(),
          token: binary(),
          user: User.t() | Ecto.Association.NotLoaded.t()
        }

  def build(user_id) do
    token = :crypto.strong_rand_bytes(@rand_size)

    %__MODULE__{token: token, user_id: user_id}
  end

  def with_token_query(token) do
    from t in __MODULE__,
      where: t.token == ^token
  end

  def user_with_token_query(token) do
    from t in __MODULE__,
      where: t.token == ^token,
      where: t.inserted_at >= ago(@session_validity_in_days, "day"),
      join: u in assoc(t, :user),
      select: u
  end
end
