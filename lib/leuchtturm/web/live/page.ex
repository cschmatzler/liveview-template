defmodule Leuchtturm.Web.PageLive do
  alias Leuchtturm.Web.Components

  use Leuchtturm.Web, :live_view

  def render(assigns) do
    ~H"""
    <.live_component module={Components.Keyboard} id="keyboard" />
    <.live_component module={Components.NavigationBar} id="navigation_bar" />
    """
  end
end
