defmodule Template.Web.AuthTest do
  use Template.ConnCase, async: true

  alias Template.Web.Auth
  alias Template.Auth.{User, Token}

  @valid_user %User{
    id: 1,
    provider: "test_provider",
    uid: "test_uid",
    email: "user1@example.com",
    name: "user1",
    image_url: "https://example.com/image.jpg"
  }
  @valid_token %Token{token: "valid_token", user_id: 1}

  setup_all do
    Hammox.defmock(AuthMock, for: Template.Auth.Behaviour)
    Application.put_env(:template, Template.Auth, AuthMock)
  end

  describe "fetch_user/2" do
    test "assigns nil if no session token is present" do
      conn = build_conn() |> init_test_session([]) |> Auth.fetch_user([])

      assert conn.assigns[:user] == nil
    end

    test "fetches user from the database and assigns it if token is present" do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> @valid_user end)

      conn =
        build_conn()
        |> init_test_session(session_token: @valid_token.token)
        |> Auth.fetch_user([])

      assert conn.assigns[:user] == @valid_user
    end
  end
end
