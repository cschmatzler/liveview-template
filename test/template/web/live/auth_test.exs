defmodule Template.Web.Live.AuthTest do
  use Template.ConnCase, async: true

  import Hammox
  import Template.Fixtures.Auth

  alias Phoenix.LiveView
  alias Template.Web.Live.Auth

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

  describe "mount: mount_user" do
    test "mounts the user if a session token is present", %{conn: conn, user: user, token: token} do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)

      session =
        conn
        |> put_session(:session_token, token.token)
        |> get_session()

      {:cont, updated_socket} = Auth.on_mount(:mount_user, %{}, session, %LiveView.Socket{})

      assert Map.has_key?(updated_socket.assigns, :user)
      assert updated_socket.assigns.user == user
    end

    test "does not mount the user if no valid session token is present", %{conn: conn} do
      session = get_session(conn)

      assert {:cont, socket} = Auth.on_mount(:mount_user, %{}, session, %LiveView.Socket{})

      assert is_nil(socket.assigns.user)
    end
  end

  describe "mount: redirect_if_unauthenticated" do
    test "redirects to signed out path if no session token is present", %{conn: conn} do
      session = get_session(conn)

      assert {:halt, _socket} =
               Auth.on_mount(:redirect_if_unauthenticated, %{}, session, %LiveView.Socket{})
    end

    test "does not redirect if valid session token is present", %{
      conn: conn,
      user: user,
      token: token
    } do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)

      session =
        conn
        |> put_session(:session_token, token.token)
        |> get_session()

      {:cont, socket_with_user} = Auth.on_mount(:mount_user, %{}, session, %LiveView.Socket{})

      assert {:cont, _socket} =
               Auth.on_mount(:redirect_if_unauthenticated, %{}, session, socket_with_user)
    end
  end
end
