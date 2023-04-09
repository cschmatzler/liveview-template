defmodule Template.Web.Auth do
  @moduledoc """
  Authentication and authorization functionality for the web service.

  This module includes functions to fetch the current user from a session, redirect users based on their
  authentication status, manage session tokens, start and end user sessions, and handle mount actions
  for authenticated LiveView components.

  The authentication process relies on session tokens stored in cookies.
  """

  use Template.Web, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Template.Auth

  @session_cookie "session"
  @max_age 60 * 60 * 24 * 7
  @session_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc false
  def session_cookie, do: @session_cookie

  @doc "Path to redirect to when an authenticated session exists."
  def signed_in_path, do: ~p"/app"

  @doc "Path to redirect to when unauthenticated."
  def signed_out_path, do: ~p"/"

  @doc "Adds a session token to the current session."
  def put_token_in_session(conn, token) do
    conn
    |> put_session(:session_token, token)
    |> put_session(:live_socket_id, "session_token:#{Base.url_encode64(token)}")
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
