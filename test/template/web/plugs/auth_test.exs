defmodule Template.Web.Plugs.AuthTest do
  use Template.ConnCase, async: true

  import Hammox
  import Template.Fixtures.Auth

  alias Template.Web.Plugs.Auth

  setup_all do
    Application.put_env(:template, Template.Auth, AuthMock)
  end

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, Template.Web.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    {token, user} = token_fixture()

    %{conn: conn, user: user, token: token}
  end

  setup :verify_on_exit!

  describe "fetch_user/2" do
    test "assigns nil if no session token is present", %{conn: conn} do
      conn = Auth.fetch_user(conn, [])

      assert conn.assigns[:user] == nil
    end

    test "fetches user from the database and assigns it if valid token is present", %{
      conn: conn,
      user: user,
      token: token
    } do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)

      conn =
        conn
        |> put_session(:session_token, token.token)
        |> Auth.fetch_user([])

      assert conn.assigns[:user] == user
    end
  end

  describe "redirect_if_unauthenticated/2" do
    test "redirects to signed out path if no user present", %{conn: conn} do
      conn = Auth.redirect_if_unauthenticated(conn, [])

      assert conn.halted
      assert redirected_to(conn) == Template.Web.Auth.signed_out_path()
    end

    test "does not redirect if user present", %{conn: conn, user: user} do
      conn = conn |> assign(:user, user) |> Auth.redirect_if_unauthenticated([])

      refute conn.halted
    end
  end

  describe "redirect_if_authenticated/2" do
    test "redirects to signed in path if user present", %{conn: conn, user: user} do
      conn = conn |> assign(:user, user) |> Auth.redirect_if_authenticated([])

      assert conn.halted
      assert redirected_to(conn) == Template.Web.Auth.signed_in_path()
    end

    test "does not redirect if no user present", %{conn: conn} do
      conn = Auth.redirect_if_authenticated(conn, [])

      refute conn.halted
    end
  end
end
