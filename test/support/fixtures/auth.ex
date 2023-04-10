defmodule Template.Fixtures.Auth do
  @moduledoc false

  use Boundary, check: [in: false, out: false]

  alias Template.Repo
  alias Template.Auth.Token
  alias Template.Auth.User

  def user_fixture(attrs \\ %{}) do
    default_attrs = %{
      provider: "google",
      uid: make_ref() |> :erlang.ref_to_list() |> List.to_string(),
      email: "google_user@example.com",
      name: "Google User",
      image: "https://example.com/image.jpg",
    }

    attrs = Map.merge(default_attrs, attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def token_fixture(attrs \\ %{token: :crypto.strong_rand_bytes(Token.token_size())}) do
    user = user_fixture()

    token =
      %Token{token: attrs.token, user_id: user.id}
      |> Repo.insert!()

    {token, user}
  end
end
