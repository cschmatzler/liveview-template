defmodule Leuchtturm.Web.AuthController do
  use Leuchtturm.Web, :controller

  alias Leuchtturm.Auth

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    provider = Atom.to_string(auth.provider)
    uid = Integer.to_string(auth.uid)

    user = get_or_create_user(provider, uid, auth.info.name, auth.info.image)
    IO.inspect(user)

    conn
    |> redirect(to: "/")
  end

  defp get_or_create_user(provider, uid, name, image_url) do
    case Auth.get_user_by_oauth(provider, uid) do
      nil ->
        create_user(provider, uid, name, image_url)

      user ->
        user
    end
  end

  defp create_user(provider, uid, name, image_url) do
    case Auth.create_user(provider, uid, name, image_url) do
      {:ok, user} ->
        user

      {:error, _changeset} ->
        :error
    end
  end
end
