defmodule Template.Web.Live.LandingTest do
  use Template.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "allows opening and closing the sidebar" do
    test "shows a button to open the sidebar", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/")

      assert html =~ "Open menu"
    end
  end
end
