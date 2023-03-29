defmodule Template.Auth.Implementation do
  alias Template.Repo
  alias Template.Auth.User
  alias Template.Auth.Token

  @behaviour Template.Auth.Behaviour

  @doc """
  Fetches a user with OAuth provider and external UID.

  Returns `nil` if no user is found.
  """
  @impl true
  def get_user_with_oauth(provider, uid) do
    User.with_oauth_query(provider, uid)
    |> Repo.one()
  end

  @doc """
  Fetches a user with a session token.

  Returns `nil` if the token does not exist or is expired.
  """
  @impl true
  def get_user_with_token(token) do
    Token.user_with_token_query(token)
    |> Repo.one()
  end

  @doc """
  Creates a new user.

  Since all the fields are provided by an external OAuth provider, there is no further error
  handling and the method raises when validation fails.
  """
  @impl true
  def create_user!(provider, uid, email, name, image_url) do
    User.changeset(%{
      provider: provider,
      uid: uid,
      email: email,
      name: name,
      image_url: image_url
    })
    |> Repo.insert!()

    :ok
  end

  @doc """
  Creates a new session token for a user.
  """
  @impl true
  def create_token!(user_id) do
    Token.build(user_id)
    |> Repo.insert!()
  end

  @doc """
  Deletes a session token.
  """
  @impl true
  def delete_token(token) do
    Token.with_token_query(token)
    |> Repo.delete_all()

    :ok
  end
end
