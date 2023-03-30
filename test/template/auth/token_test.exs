defmodule Template.Auth.TokenTest do
  use Template.DataCase, async: true

  import Template.Fixtures.Auth

  alias Template.Auth.Token

  setup do
    {token, user} = token_fixture()

    %{token: token, user: user}
  end

  describe "build/1" do
    test "returns a token with a token string of the correct length" do
      token = Token.build(0)

      assert byte_size(token.token) == Token.token_size()
    end

    test "returns a token with the given user id" do
      user_id = 0
      token = Token.build(user_id)

      assert token.user_id == user_id
    end
  end

  describe "with_token_query/1" do
    test "returns a query that fetches the token with the given token string", %{token: token} do
      query = Token.with_token_query(token.token)

      assert Repo.one(query) == token
    end

    test "returns a query that does not fetch any token if the given token string does not exist" do
      query = Token.with_token_query("invalid_token")

      refute Repo.one(query)
    end
  end

  describe "user_with_token_query/1" do
    test "returns a query that fetches a user if the token is valid and not expired", %{
      token: token,
      user: user
    } do
      query = Token.user_with_token_query(token.token)

      assert Repo.one(query) == user
    end

    test "returns a query that does not fetch a user if the token is invalid" do
      query = Token.user_with_token_query("invalid_token")

      refute Repo.one(query)
    end

    test "returns a query that does not fetch a user if the token is expired", %{token: token} do
      expired_date =
        DateTime.utc_now()
        |> DateTime.add(-Token.session_validity_in_days(), :day)
        |> DateTime.truncate(:second)

      Ecto.Changeset.change(token, inserted_at: expired_date) |> Repo.update!()

      query = Token.user_with_token_query(token.token)

      refute Repo.one(query)
    end
  end
end
