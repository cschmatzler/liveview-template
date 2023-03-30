defmodule Template.Auth.Behaviour do
  @moduledoc """
  """
  # TODO: Write proper documentation

  alias Template.Auth.{Token, User}

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

  Since all the fields are provided by an external OAuth provider, there is no further error
  handling and the method raises when validation fails.
  """
  @callback create_user!(
              provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t(),
              image_url :: String.t() | nil
            ) ::
              User.t()

  @doc """
  Creates a new session token for a user.
  """
  @callback create_token!(user_id :: integer()) :: Token.t()

  @doc """
  Deletes a session token.
  """
  @callback delete_token(token :: binary()) :: :ok
end
