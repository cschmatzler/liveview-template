defmodule Template.Fixtures.Auth do
  @moduledoc false

  use Boundary, check: [in: false, out: false]

  alias Template.Repo
  alias Template.Auth.{Token, User}

  @default_user_attrs %{
    provider: "google",
    uid: make_ref() |> :erlang.ref_to_list() |> List.to_string(),
    email: "google_user@example.com",
    name: "Google User",
    image: "https://example.com/image.jpg"
  }
  def user_fixture(attrs \\ %{}) do
    attrs = Map.merge(@default_user_attrs, attrs)

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
