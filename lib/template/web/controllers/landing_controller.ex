defmodule Template.Web.LandingController do
  use Template.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

defmodule Template.Web.LandingHTML do
  use Template.Web, :component

  alias Template.Web.Components.Buttons.OAuth

  embed_templates "landing/*"
end
