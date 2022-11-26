defmodule Leuchtturm.Web.Utilities.Authentication do
  alias Leuchtturm.Authentication

  use Leuchtturm.Web, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  @max_age 60 * 60 * 24 * 60
  @remember_session_cookie "_remember_session"
  @remember_session_options [sign: true, max_age: @max_age, same_site: "Lax"]

  # ------------
  # Route helpers
  # ------------
  def fetch_logged_in_user(conn, _opts) do
    {session_token, conn} = ensure_session_token(conn)
    user = session_token && Authentication.get_user_by_session_token(session_token)

    assign(conn, :user, user)
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  # LiveView helpers
  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.user do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  # ------------
  # User actions
  # ------------
  def login(conn, user, params \\ %{}) do
    token = Authentication.generate_user_session_token(user)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: signed_in_path(conn))
  end

  defp signed_in_path(_conn), do: ~p"/"

  defp mount_current_user(session, socket) do
    case session do
      %{"session_token" => session_token} ->
        Phoenix.Component.assign_new(socket, :user, fn ->
          Authentication.get_user_by_session_token(session_token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :user, fn -> nil end)
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:session_token, token)
    |> put_session(:live_socket_id, "session_token:#{Base.url_encode64(token)}")
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_session_cookie, token, @remember_session_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  defp ensure_session_token(conn) do
    if token = get_session(conn, :session_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_session_cookie])

      if token = conn.cookies[@remember_session_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end
end
