defmodule Template.Web.Live.AuthTest do
  # NOTE: does the `Application.put_env` mock still allow us to run this async?
  # Will see during integration tests.
  use Template.ConnCase, async: false

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

    user = user_fixture(%{role: :user})
    admin_user = user_fixture(%{role: :admin})

    %{conn: conn, user: user, admin_user: admin_user}
  end

  setup :verify_on_exit!

  describe "mount: mount_user" do
    test "mounts the user if a session token is present", %{conn: conn, user: user} do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)

      session =
        conn
        |> put_session(:session_token, "token")
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

  describe "mount: require_session" do
    test "redirects to signed out path if no session token is present", %{conn: conn} do
      session = get_session(conn)

      assert {:halt, _socket} = Auth.on_mount(:require_session, %{}, session, %LiveView.Socket{})
    end

    test "does not redirect if valid session token is present", %{conn: conn, user: user} do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)

      session =
        conn
        |> put_session(:session_token, "token")
        |> get_session()

      {:cont, socket_with_user} = Auth.on_mount(:mount_user, %{}, session, %LiveView.Socket{})

      assert {:cont, _socket} = Auth.on_mount(:require_session, %{}, session, socket_with_user)
    end
  end

  describe "mount: require_admin" do
    test "redirects to signed out path if the user is not an admin", %{conn: conn} do
      session = get_session(conn)

      assert {:halt, _socket} = Auth.on_mount(:require_admin, %{}, session, %LiveView.Socket{})
    end

    test "does not redirect if the session user is an admin", %{
      conn: conn,
      admin_user: admin_user
    } do
      Hammox.stub(AuthMock, :get_user_with_token, fn _ -> admin_user end)

      session =
        conn
        |> put_session(:session_token, "token")
        |> get_session()

      {:cont, socket_with_user} = Auth.on_mount(:mount_user, %{}, session, %LiveView.Socket{})

      assert {:cont, _socket} = Auth.on_mount(:require_admin, %{}, session, socket_with_user)
    end
  end
end
