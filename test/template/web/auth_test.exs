defmodule Template.Web.AuthTest do
  use Template.ConnCase, async: true

  import Hammox
  import Template.Fixtures.Auth

  alias Template.Web.Auth

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

  describe "start_session/2" do
    setup %{token: token} do
      Hammox.stub(AuthMock, :create_token!, fn _ -> token end)

      :ok
    end

    test "clears the existing session", %{conn: conn, user: user} do
      conn = conn |> put_session(:old_token, "value") |> Auth.start_session(user)

      refute get_session(conn, :old_token)
    end

    test "stores the token in the session", %{conn: conn, user: user, token: token} do
      conn = Auth.start_session(conn, user)

      assert token.token == get_session(conn, :session_token)
    end

    test "stores the token in a cookie", %{conn: conn, user: user, token: token} do
      conn = conn |> fetch_cookies() |> Auth.start_session(user)

      assert token.token == conn.cookies["session"]
      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies["session"]
      assert signed_token != get_session(conn, :session_token)
      assert max_age == 604_800
    end

    test "stores the token as live socket identifier", %{conn: conn, user: user, token: token} do
      conn = Auth.start_session(conn, user)

      assert get_session(conn, :live_socket_id) ==
               "session_token:#{Base.url_encode64(token.token)}"
    end

    test "redirects to signed out path", %{conn: conn, user: user} do
      conn = Auth.start_session(conn, user)

      assert redirected_to(conn) == Auth.signed_in_path()
    end
  end

  describe "end_session/2" do
    setup do
      Hammox.stub(AuthMock, :delete_token, fn _ -> :ok end)

      :ok
    end

    test "erases the session", %{conn: conn, token: token} do
      conn = conn |> put_session(:session_token, token.token) |> Auth.end_session()

      refute get_session(conn, :session_token)
    end

    test "erases the cookie", %{conn: conn, token: token} do
      conn =
        conn
        |> put_req_cookie("session", token.token)
        |> fetch_cookies()
        |> Auth.end_session()

      refute conn.cookies["session"]
      assert %{max_age: 0} = conn.resp_cookies["session"]
    end

    test "it broadcasts a disconnect signal to the live socket identifier", %{conn: conn} do
      live_socket_id = "test-socket-id"
      Template.Web.Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> Auth.end_session()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "it redirects to signed out path", %{conn: conn, token: token} do
      conn = conn |> put_session(:session_token, token.token) |> Auth.end_session()

      assert redirected_to(conn) == Auth.signed_out_path()
    end

    test "it does not error when no user is logged in", %{conn: conn} do
      conn = Auth.end_session(conn)

      refute get_session(conn, :session_token)
      assert redirected_to(conn) == Auth.signed_out_path()
    end
  end
end
