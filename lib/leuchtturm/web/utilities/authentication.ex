defmodule Leuchtturm.Web.Utilities.Authentication do
  alias Leuchtturm.Authentication

  use Leuchtturm.Web, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  @max_age 60 * 60 * 24 * 60
  @remember_session_cookie "_remember_session"
  @remember_session_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def login(conn, user, params \\ %{}) do
    token = Authentication.generate_user_session_token(user)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: signed_in_path(conn))
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

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_session_cookie, token, @remember_session_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  defp signed_in_path(_conn), do: ~p"/"
end
