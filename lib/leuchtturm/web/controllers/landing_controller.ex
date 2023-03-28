defmodule Leuchtturm.Web.LandingController do
  use Leuchtturm.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

defmodule Leuchtturm.Web.LandingHTML do
  use Leuchtturm.Web, :component

  embed_templates "landing/*"
end
