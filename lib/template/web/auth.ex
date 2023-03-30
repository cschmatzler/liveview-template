defmodule Template.Web.Auth do
  @moduledoc """
  The `Template.Web.Auth` module provides authentication functionality for the web application.

  This module includes functions to fetch the current user from a session, redirect users based on their
  authentication status, manage session tokens, start and end user sessions, and handle mount actions
  for authenticated LiveView components.

  The authentication process relies on session tokens stored in cookies.
  """

  use Template.Web, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Template.Auth.Facade, as: Auth

  @session_cookie "session"
  @max_age 60 * 60 * 24 * 7
  @session_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Handles mount actions for authenticated LiveView components.

  Mounts the session user from the initial connection as `assigns.user`.
  If no authenticated session exists, halts the mount and redirects to `signed_out_path/0`.

  ## Usage
      # Router
      live_session :authenticated, on_mount: {Template.Web.Auth, :redirect_if_authenticated} do
        scope "/", Template.Web do
          pipe_through :browser

          live "/profile", UserLive.Profile, :index
        end
      end
  end
  """
  def on_mount(:redirect_if_unauthenticated, _params, session, socket) do
    socket = mount_user(session, socket)

    if socket.assigns.user do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_out_path())}
    end
  end

  @doc """
  Reads the session token from the browser session or cookies, whichever is available, and, if the
  token is valid, assigns the corresponding user to the connection.

  ## Usage
      # Router
      pipe_through :fetch_user
  """
  def fetch_user(conn, _opts) do
    {session_token, conn} = ensure_session_token(conn)
    user = session_token && Auth.get_user_with_token(session_token)

    assign(conn, :user, user)
  end

  @doc """
  Redirects the connection to `signed_out_path/0` if no authenticated session exists.

  ## Usage
      # Router
      pipe_through :redirect_if_unauthenticated
  """
  def redirect_if_unauthenticated(conn, _opts) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> redirect(to: signed_out_path())
      |> halt()
    end
  end

  @doc """
  Redirects the connection to `signed_in_path/0` if an authenticated session exists.

  ## Usage
      # Router
      pipe_through :redirect_if_authenticated
  """
  def redirect_if_authenticated(conn, _opts) do
    if conn.assigns[:user] do
      conn
      |> redirect(to: signed_in_path())
      |> halt()
    else
      conn
    end
  end

  @doc "Path to redirect to when an authenticated session exists."
  def signed_in_path, do: ~p"/app"

  @doc "Path to redirect to when unauthenticated."
  def signed_out_path, do: ~p"/"

  defp ensure_session_token(conn) do
    if token = get_session(conn, :session_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [@session_cookie])

      if token = conn.cookies[@session_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:session_token, token)
    |> put_session(:live_socket_id, "session_token:#{Base.url_encode64(token)}")
  end

  defp mount_user(session, socket) do
    case session do
      %{"session_token" => session_token} ->
        Phoenix.Component.assign_new(socket, :user, fn ->
          Auth.get_user_with_token(session_token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :user, fn -> nil end)
    end
  end

  @doc """
  Creates a new authenticated session.

  Creates and persists a session token, which is then added to the browser session and stored as a
  session cookie. Afterwards, redirects to `signed_in_path/0`.
  """
  def start_session(conn, user) do
    token = Auth.create_token!(user.id).token

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> write_session_cookie(token)
    |> redirect(to: signed_in_path())
  end

  @doc """
  Ends an authenticated session, if one exists.

  Deletes the session token from the business layer, broadcasts a disconnect event to all
  connected LiveViews so that existing persistent connections are closed, preventing the
  user from inadvertently staying authenticated.
  """
  def end_session(conn) do
    session_token = get_session(conn, :session_token)
    session_token && Auth.delete_token(session_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      Template.Web.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@session_cookie)
    |> redirect(to: signed_out_path())
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp write_session_cookie(conn, token) do
    put_resp_cookie(conn, @session_cookie, token, @session_options)
  end
end
