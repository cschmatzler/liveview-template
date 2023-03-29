defmodule Template.Web.PageLive do
  use Template.Web, :live_view

  import Template.Web.Components

  alias Template.Web.Components.Keyboard

  def render(assigns) do
    ~H"""
    <.live_component module={Keyboard} id="keyboard" /> Hello! <.card /> Whatup
    """
  end
end
