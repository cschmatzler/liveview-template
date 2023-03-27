defmodule Leuchtturm.Web.PageLive do
  use Leuchtturm.Web, :live_view

  import Leuchtturm.Web.Components, only: [card: 1]

  alias Leuchtturm.Web.Components.Keyboard

  def render(assigns) do
    ~H"""
    <.live_component module={Keyboard} id="keyboard" /> Hello! <.card />
    """
  end
end
