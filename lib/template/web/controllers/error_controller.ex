defmodule Template.Web.Controllers.ErrorController do
  use Template.Web, :controller

  def index(_conn, _params) do
    raise "Oh no!"
  end
end
