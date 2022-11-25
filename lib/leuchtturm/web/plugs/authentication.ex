defmodule Leuchtturm.Web.Plugs.Authentication do
  use Leuchtturm.Web, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_remember_session"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def fetch_logged_in_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    # TODO: Authentication does not exist yet
    user = user_token && Authentication.get_user_by_session_token(user_token)
    assign(conn, :user, user)
  end

  defp ensure_user_token(conn) do
    if token = get_session(conn, :user_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if token = conn.cookies[@remember_me_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "sessions:#{Base.url_encode64(token)}")
  end

  defp signed_in_path(_conn), do: ~p"/"
end
