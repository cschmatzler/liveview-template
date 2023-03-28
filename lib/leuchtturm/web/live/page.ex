defmodule Leuchtturm.Web.PageLive do
  use Leuchtturm.Web, :live_view

  import Leuchtturm.Web.Components

  alias Leuchtturm.Web.Components.Keyboard

  def render(assigns) do
    ~H"""
    <.live_component module={Keyboard} id="keyboard" /> Hello! <.card /> Whatup
    """
  end
end
