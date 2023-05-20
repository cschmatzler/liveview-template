defmodule Template.Web.Pages.Auth.Error do
  use Template.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

defmodule Template.Web.Pages.Auth.ErrorHTML do
  use Template.Web, :component

  embed_templates("error/*")
end
