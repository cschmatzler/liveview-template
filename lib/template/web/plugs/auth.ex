defmodule Template.Web.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Template.Web.Auth, only: [signed_in_path: 0, signed_out_path: 0, session_cookie: 0]

  alias Template.Auth

  @doc """
  Reads the session token from the browser session or cookies, whichever is available, and, if the
  token is valid, assigns the corresponding user to the connection.

  ## Usage
      # Router
      plug :fetch_user
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
      plug :redirect_if_unauthenticated
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
      plug :redirect_if_authenticated
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

  defp ensure_session_token(conn) do
    if token = get_session(conn, :session_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [session_cookie()])

      if token = conn.cookies[session_cookie()] do
        {token, Template.Web.Auth.put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end
end
