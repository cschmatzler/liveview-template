defmodule Leuchtturm.Web.AuthController do
  use Leuchtturm.Web, :controller

  alias Leuchtturm.Auth

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    provider = to_string(auth.provider)
    uid = to_string(auth.uid)

    user = get_or_create_user(provider, uid, auth.info.email, auth.info.name, auth.info.image)
    Leuchtturm.Web.Auth.login(conn, user)

    conn
    |> redirect(to: ~p"/app")
  end

  def logout(conn, _params) do
    Leuchtturm.Web.Auth.logout(conn)

    conn
    |> redirect(to: ~p"/")
  end

  defp get_or_create_user(provider, uid, email, name, image_url) do
    case Auth.get_user_by_oauth(provider, uid) do
      nil ->
        Auth.create_user!(provider, uid, email, name, image_url)

      user ->
        user
    end
  end
end
