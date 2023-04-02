defmodule Template.Web.Controllers.LandingControllerTest do
  use Template.ConnCase, async: false

  import Hammox
  import Template.Fixtures.Auth

  alias Template.Web.Auth

  setup_all do
    Hammox.defmock(AuthMock, for: Template.Auth)
    Application.put_env(:template, Template.Auth, AuthMock)
  end

  setup :verify_on_exit!

  # defp with_session(%{conn: conn}) do
  #   {token, user} = token_fixture()
  #   Hammox.stub(AuthMock, :get_user_with_token, fn _ -> user end)
  #
  #   document =
  #     conn
  #     |> init_test_session(%{})
  #     |> put_session(:session_token, token.token)
  #     |> get(~p"/")
  #     |> html_response(200)
  #     |> Floki.parse_document!()
  #
  #   %{document: document}
  # end
  #
  defp without_session(%{conn: conn}) do
    document = conn |> get(~p"/") |> html_response(200) |> Floki.parse_document!()

    %{document: document}
  end

  describe "sign-in (without session)" do
    setup :without_session

    test "renders a collapsible popover menu to sign in via OAuth", %{document: document} do
      assert Floki.find(document, "button#sign-in-popover-toggle") |> Enum.any?()

      assert Floki.find(
               document,
               "div#sign-in-popover a#sign-in-popover-google[href*=\"google\"]"
             )
             |> Enum.any?()

      assert Floki.find(
               document,
               "div#sign-in-popover a#sign-in-popover-github[href*=\"github\"]"
             )
             |> Enum.any?()
    end

    test "renders a sidebar entry to sign in via OAuth", %{document: document} do
      assert Floki.find(
               document,
               "div#sign-in-sidebar a#sign-in-sidebar-google[href*=\"google\"]"
             )
             |> Enum.any?()

      assert Floki.find(
               document,
               "div#sign-in-sidebar a#sign-in-sidebar-github[href*=\"github\"]"
             )
             |> Enum.any?()
    end

    test "does not render any button to go to the signed in path", %{document: document} do
      refute Floki.find(document, "a[href=\"#{Auth.signed_in_path()}\"]") |> Enum.any?()
    end
  end
end
