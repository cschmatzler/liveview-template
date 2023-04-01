defmodule Template.Web.PageLive do
  use Template.Web, :live_view

  alias Template.Web.Components.KeyboardHandler

  def render(assigns) do
    ~H"""
    <.live_component module={KeyboardHandler} id="keyboard-handler" keydown_enabled="true" /> Hello!
    """
  end

  def handle_info({:keydown, key}, socket) do
    IO.inspect("Keydown: #{key}")

    {:noreply, socket}
  end
end
