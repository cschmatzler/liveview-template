defmodule Template.Web.Pages.Auth.Error do
  use Template.Web, :controller

  def index(conn, params) do
    error_id = Map.get(params, "id")
    error = Ory.Api.Frontend.get_flow_error(Ory.Connection.new(), error_id)
    IO.inspect(error)

    render(conn, :index)
  end
end

defmodule Template.Web.Pages.Auth.ErrorHTML do
  use Template.Web, :component

  embed_templates("error/*")
end
