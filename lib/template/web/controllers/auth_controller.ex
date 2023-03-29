defmodule Template.Web.AuthController do
  use Template.Web, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Template.Web.Auth.signed_out_path())
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    provider = to_string(auth.provider)
    uid = to_string(auth.uid)
    user = get_or_create_user(provider, uid, auth.info.email, auth.info.name, auth.info.image)

    Template.Web.Auth.start_session(conn, user)
  end

  def logout(conn, _params) do
    Template.Web.Auth.end_session(conn)
  end

  defp get_or_create_user(provider, uid, email, name, image_url) do
    if user = Template.Auth.get_user_with_oauth(provider, uid) do
      user
    else
      Template.Auth.create_user!(provider, uid, email, name, image_url)
    end
  end
end
