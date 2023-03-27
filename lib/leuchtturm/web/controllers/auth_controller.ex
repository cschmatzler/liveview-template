defmodule Leuchtturm.Web.AuthController do
  use Leuchtturm.Web, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: _auth}} = conn, _params) do
    # TODO: Create or find user account

    conn
  end
end
