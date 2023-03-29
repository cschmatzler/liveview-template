defmodule Leuchtturm.Web.AuthController do
  use Leuchtturm.Web, :controller

  alias Leuchtturm.Auth

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Leuchtturm.Web.Auth.signed_out_path())
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    provider = to_string(auth.provider)
    uid = to_string(auth.uid)

    user = get_or_create_user(provider, uid, auth.info.email, auth.info.name, auth.info.image)

    Leuchtturm.Web.Auth.start_session(conn, user)
  end

  def logout(conn, _params) do
    Leuchtturm.Web.Auth.end_session(conn)
  end

  defp get_or_create_user(provider, uid, email, name, image_url) do
    if user = Auth.get_user_with_oauth(provider, uid) do
      user
    else
      Auth.create_user!(provider, uid, email, name, image_url)
    end
  end
end
