defmodule Template.Auth.Impl do
  @moduledoc """
  The default implementation of `Template.Auth`.
  """

  @behaviour Template.Auth

  alias Template.Auth.Token
  alias Template.Auth.User
  alias Template.Repo

  @impl Template.Auth
  def get_user_with_oauth(provider, uid) do
    provider
    |> User.with_oauth_query(uid)
    |> Repo.one()
  end

  @impl Template.Auth
  def get_user_with_token(token) do
    token
    |> Token.user_with_token_query()
    |> Repo.one()
  end

  @impl Template.Auth
  def create_user(provider, uid, email, name, image_url) do
    %{
      provider: provider,
      uid: uid,
      email: email,
      name: name,
      image_url: image_url
    }
    |> User.changeset()
    |> Repo.insert()
  end

  @impl Template.Auth
  def create_token!(user_id) do
    user_id
    |> Token.build()
    |> Repo.insert!()
  end

  @impl Template.Auth
  def delete_token(token) do
    token
    |> Token.with_token_query()
    |> Repo.delete_all()

    :ok
  end
end
