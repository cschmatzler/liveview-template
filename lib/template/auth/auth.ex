defmodule Template.Auth do
  @moduledoc """
  Aggregate for authentication and authorization.

  Login and signup are handled by using external OAuth providers. At the moment, these are Google
  and GitHub.
  For session persistence, tokens are used.

  The default implementation lives in `Template.Auth.Implementation`.
  """

  use Boundary, deps: [Template.Repo], exports: [User], top_level?: true

  use Knigge,
    otp_app: :template,
    default: Template.Auth.Impl

  alias Template.Auth.Token
  alias Template.Auth.User

  @doc """
  Fetches a user with OAuth provider and external UID.

  Returns `nil` if no user is found.
  """
  @callback get_user_with_oauth(provider :: String.t(), uid :: String.t()) :: User.t() | nil

  @doc """
  Fetches a user with a session token.

  Returns `nil` if the token does not exist or is expired.
  """
  @callback get_user_with_token(token :: binary()) :: User.t() | nil

  @doc """
  Creates a new user.
  """
  @callback create_user(
              provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t(),
              image_url :: String.t() | nil
            ) ::
              {:ok, User.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Creates a new session token for a user.
  """
  @callback create_token!(user_id :: integer()) :: Token.t()

  @doc """
  Deletes a session token.
  """
  @callback delete_token(token :: binary()) :: :ok
end
