defmodule Template.Web.Controllers.LandingController do
  @moduledoc """
  Application's landing page.
  """

  use Template.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

defmodule Template.Web.Controllers.LandingHTML do
  @moduledoc false

  use Template.Web, :component

  embed_templates "landing/*"
end
