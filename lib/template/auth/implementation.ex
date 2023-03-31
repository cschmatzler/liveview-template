defmodule Template.Auth.Implementation do
  @moduledoc """
  The default implementation of `Template.Auth`.
  """

  @behaviour Template.Auth

  alias Template.Repo
  alias Template.Auth.Token
  alias Template.Auth.User

  @impl Template.Auth
  def get_user_with_oauth(provider, uid) do
    User.with_oauth_query(provider, uid)
    |> Repo.one()
  end

  @impl Template.Auth
  def get_user_with_token(token) do
    Token.user_with_token_query(token)
    |> Repo.one()
  end

  @impl Template.Auth
  def create_user!(provider, uid, email, name, image_url) do
    User.changeset(%{
      provider: provider,
      uid: uid,
      email: email,
      name: name,
      image_url: image_url
    })
    |> Repo.insert!()
  end

  @impl Template.Auth
  def create_token!(user_id) do
    Token.build(user_id)
    |> Repo.insert!()
  end

  @impl Template.Auth
  def delete_token(token) do
    Token.with_token_query(token)
    |> Repo.delete_all()

    :ok
  end
end
