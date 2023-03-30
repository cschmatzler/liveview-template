defmodule Template.Auth.Token do
  @moduledoc """
  Model for a session token.
  """

  use Ecto.Schema

  import Ecto.Query

  alias Template.Auth.User

  @token_size 32
  @session_validity_in_days 7

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "tokens" do
    field :token, :binary
    belongs_to :user, Template.Auth.User
    timestamps(updated_at: false)
  end

  @type t :: %__MODULE__{
          id: integer(),
          token: binary(),
          user: User.t() | Ecto.Association.NotLoaded.t()
        }

  @doc false
  def token_size, do: @token_size
  @doc false
  def session_validity_in_days, do: @session_validity_in_days

  @doc """
  Builds a session token.

  Generates a random token with length `@token_size` and associates it with the given user.
  """
  @spec build(integer()) :: %__MODULE__{}
  def build(user_id) do
    token = :crypto.strong_rand_bytes(@token_size)

    %__MODULE__{token: token, user_id: user_id}
  end

  @doc """
  Builds a query for fetching a token with the given token string.
  """
  @spec with_token_query(binary()) :: Ecto.Query.t()
  def with_token_query(token) do
    from t in __MODULE__,
      where: t.token == ^token
  end

  @doc """
  Builds a query for fetching a user with the given token string.

  Only returns a user if the token has not expired, i.e. it has been created within the last
  `@session_validity_in_days` days.
  """
  def user_with_token_query(token) do
    from t in __MODULE__,
      where: t.token == ^token,
      where: t.inserted_at >= ago(@session_validity_in_days, "day"),
      join: u in assoc(t, :user),
      select: u
  end
end
