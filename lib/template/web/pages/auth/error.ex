defmodule Template.Web.Pages.Auth.Error do
  @moduledoc false
  use Template.Web, :controller

  def index(conn, %{"id" => error_id}) do
    error = Kratos.Frontend.get_flow_error(error_id, cookie_header(conn))
    IO.inspect(error)

    render(conn, :index)
  end
end

defmodule Template.Web.Pages.Auth.ErrorHTML do
  use Template.Web, :component

  embed_templates("error/*")
end
