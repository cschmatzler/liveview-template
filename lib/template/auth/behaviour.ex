defmodule Template.Auth.Behaviour do
  alias Template.Auth.{Token, User}

  @callback get_user_with_oauth(provider :: String.t(), uid :: String.t()) :: User.t() | nil
  @callback get_user_with_token(token :: binary()) :: User.t() | nil
  @callback create_user!(
              provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t(),
              image_url :: String.t() | nil
            ) ::
              User.t()
  @callback create_token!(user_id :: integer()) :: Token.t()
  @callback delete_token(token :: binary()) :: :ok
end
