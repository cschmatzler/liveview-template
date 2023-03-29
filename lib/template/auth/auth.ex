defmodule Template.Auth do
  @moduledoc """
  TODO: Add a description
  """

  use Boundary, deps: [Template.Repo], top_level?: true

  alias Template.Repo
  alias Template.Auth.User
  alias Template.Auth.Token

  @spec get_user_with_oauth(String.t(), String.t()) :: User.t() | nil
  def get_user_with_oauth(provider, uid) do
    User.with_oauth_query(provider, uid)
    |> Repo.one()
  end

  def get_user_with_token(token) do
    Token.user_with_token_query(token)
    |> Repo.one()
  end

  @spec create_user!(String.t(), String.t(), String.t(), String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
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

  @spec create_token!(integer()) :: Token.t()
  def create_token!(user_id) do
    Token.build(user_id)
    |> Repo.insert!()
  end

  def delete_token(token) do
    Token.with_token_query(token)
    |> Repo.delete_all()
  end
end
