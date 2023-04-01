defmodule Template.Web.Controllers.AuthController do
  @moduledoc """
  Web authentication controller.

  Starts OAuth requests, handles callbacks and manages session tokens.
  """

  use Template.Web, :controller

  alias Template.Auth

  plug Ueberauth

  @doc """
  Starts an OAuth request.

  The general handling is provided by Ueberauth by calling `plug Ueberauth`.
  Ueberauth currently does not gracefully handle unknown providers, so we are adding an extra
  function clause here that matches on any provider - if the requested provider wasn't matched by
  Ueberauth before, an error is returned.
  """
  def request(conn, _params) do
    conn
    |> put_flash(:login_error, true)
    |> redirect(to: Template.Web.Auth.signed_out_path())
  end

  @doc """
  Handles an OAuth callback.

  Outcome of the OAuth request is handled by Ueberauth. The two function clauses of this handler
  are matching on Ueberauth's results and whether `ueberauth_failure` or `ueberauth_auth` is
  present in the connection.
  """
  def callback(conn, params)

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:login_error, true)
    |> redirect(to: Template.Web.Auth.signed_out_path())
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    provider = to_string(auth.provider)
    uid = to_string(auth.uid)

    user = get_or_create_user(provider, uid, auth.info.email, auth.info.name, auth.info.image)

    case user do
      {:ok, user} ->
        Template.Web.Auth.start_session(conn, user)

      {:error, _error} ->
        conn
        |> put_flash(:login_error, true)
        |> redirect(to: Template.Web.Auth.signed_out_path())
    end
  end

  @doc """
  Ends an authenticated session.
  """
  def logout(conn, _params) do
    Template.Web.Auth.end_session(conn)
  end

  defp get_or_create_user(provider, uid, email, name, image_url) do
    if user = Auth.get_user_with_oauth(provider, uid) do
      {:ok, user}
    else
      Auth.create_user(provider, uid, email, name, image_url)
    end
  end
end
