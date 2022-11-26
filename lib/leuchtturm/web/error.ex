defmodule Leuchtturm.Web.ErrorHTML do
  # TODO: put this in the right spot, wherever that is
  @moduledoc false

  use Leuchtturm.Web, :html

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

