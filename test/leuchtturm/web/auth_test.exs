defmodule Template.Web.AuthTest do
  use Template.ConnCase, async: true

  alias Phoenix.LiveView
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
  @valid_token %Token{id: 1, token: "valid_token", user_id: 1}

  setup_all do
    Hammox.defmock(AuthMock, for: Template.Auth.Behaviour)
    Application.put_env(:template, Template.Auth.Facade, AuthMock)
  end

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, Template.Web.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{conn: conn}
  end

  describe "mount: redirect_if_unauthenticated" do
    test "redirects to signed out path if no session token is present", %{conn: conn} do
      session = get_session(conn)

      socket = %LiveView.Socket{
        endpoint: Template.Web.Endpoint,
        assigns: %{__changed__: %{}, flash: %{}}
      }

      {:halt, updated_socket} = Auth.on_mount(:redirect_if_unauthenticated, %{}, session, socket)

      assert updated_socket.assigns.user == nil
    end

    test "fetches user from the database and mounts it if valid token is present", %{conn: conn} do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> @valid_user end)

      session =
        conn
        |> put_session(:session_token, @valid_token.token)
        |> get_session()

      {:cont, updated_socket} =
        Auth.on_mount(:redirect_if_unauthenticated, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.user == @valid_user
    end
  end

  describe "fetch_user/2" do
    test "assigns nil if no session token is present", %{conn: conn} do
      conn = Auth.fetch_user(conn, [])

      assert conn.assigns[:user] == nil
    end

    test "fetches user from the database and assigns it if valid token is present", %{conn: conn} do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> @valid_user end)

      conn =
        conn
        |> put_session(:session_token, @valid_token.token)
        |> Auth.fetch_user([])

      assert conn.assigns[:user] == @valid_user
    end
  end

  describe "redirect_if_unauthenticated/2" do
    test "redirects to signed out path if no user present", %{conn: conn} do
      conn = Auth.redirect_if_unauthenticated(conn, [])

      assert conn.halted
      assert redirected_to(conn) == Auth.signed_out_path()
    end

    test "does not redirect if user present", %{conn: conn} do
      conn = conn |> assign(:user, @valid_user) |> Auth.redirect_if_unauthenticated([])

      refute conn.halted
    end
  end

  describe "redirect_if_authenticated/2" do
    test "redirects to signed in path if user present", %{conn: conn} do
      conn = conn |> assign(:user, @valid_user) |> Auth.redirect_if_authenticated([])

      assert conn.halted
      assert redirected_to(conn) == Auth.signed_in_path()
    end

    test "does not redirect if no user present", %{conn: conn} do
      conn = Auth.redirect_if_authenticated(conn, [])

      refute conn.halted
    end
  end

  describe "start_session/2" do
    setup do
      Hammox.stub(AuthMock, :create_token!, fn _ -> @valid_token end)

      :ok
    end

    test "clears the existing session", %{conn: conn} do
      conn = conn |> put_session(:old_token, "value") |> Auth.start_session(@valid_user)

      refute get_session(conn, :old_token)
    end

    test "stores the token in the session", %{conn: conn} do
      conn = Auth.start_session(conn, @valid_user)

      assert @valid_token.token == get_session(conn, :session_token)
    end

    test "stores the token in a cookie", %{conn: conn} do
      conn = conn |> fetch_cookies() |> Auth.start_session(@valid_user)

      assert @valid_token.token == conn.cookies["session"]
      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies["session"]
      assert signed_token != get_session(conn, :user_token)
      assert max_age == 604_800
    end

    test "stores the token as live socket identifier", %{conn: conn} do
      conn = Auth.start_session(conn, @valid_user)

      assert get_session(conn, :live_socket_id) ==
               "session_token:#{Base.url_encode64(@valid_token.token)}"
    end

    test "redirects to signed out path", %{conn: conn} do
      conn = Auth.start_session(conn, @valid_user)

      assert redirected_to(conn) == Auth.signed_in_path()
    end
  end

  describe "end_session/2" do
    setup do
      Hammox.stub(AuthMock, :delete_token, fn _ -> :ok end)

      :ok
    end

    test "erases the session", %{conn: conn} do
      conn = conn |> put_session(:session_token, @valid_token.token) |> Auth.end_session()

      refute get_session(conn, :session_token)
    end

    test "erases the cookie", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie("session", @valid_token.token)
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

    test "it redirects to signed out path", %{conn: conn} do
      conn = conn |> put_session(:session_token, @valid_token.token) |> Auth.end_session()

      assert redirected_to(conn) == Auth.signed_out_path()
    end

    test "it does not error when no user is logged in", %{conn: conn} do
      conn = Auth.end_session(conn)

      refute get_session(conn, :session_token)
      assert redirected_to(conn) == Auth.signed_out_path()
    end
  end
end
