defmodule Template.Auth.UserTest do
  use Template.DataCase, async: true

  import Template.Fixtures.Auth

  alias Template.Auth.User

  setup do
    user = user_fixture()

    %{user: user}
  end

  describe "with_oauth_query/2" do
    test "returns a query to fetch the user with the given provider and uid", %{user: user} do
      query = User.with_oauth_query(user.provider, user.uid)

      assert Repo.one(query) == user
    end

    test "returns a query that does not fetch any user if the provider/uid combination does not exist" do
      provider = "unknown_provider"
      uid = "0"

      query = User.with_oauth_query(provider, uid)
      user = Repo.one(query)

      assert is_nil(user)
    end
  end

  describe "create_token!/1" do
    
  end
end
