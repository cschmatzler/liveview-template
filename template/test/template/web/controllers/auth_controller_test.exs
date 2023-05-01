defmodule Template.Web.Controllers.AuthControllerTest do
  use Template.ConnCase, async: true

  alias Template.Web.Auth

  describe "request" do
    test "redirects to signed out path and adds an error if provider is unknown", %{conn: conn} do
      conn = get(conn, "/auth/invalid_provider")

      assert redirected_to(conn) == Auth.signed_out_path()
      assert Phoenix.Flash.get(conn.assigns.flash, :login_error) == true
    end
  end
end
