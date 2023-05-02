defmodule Template.Web.Components.KeyboardHandler do
  @moduledoc """
  Component for handling keyboard events.
  """

  use Template.Web, :live_component

  attr :keydown_enabled, :boolean, default: false
  attr :keyup_enabled, :boolean, default: false

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div
      id={"#{@id}"}
      phx-hook="Keyboard"
      data-keydown-enabled={@keydown_enabled}
      data-keyup-enabled={@keyup_enabled}
      data-target={@myself}
      aria-hidden="true"
    >
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def handle_event("keydown", %{"key" => key}, socket) do
    send(self(), {:keydown, key})

    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("keyup", %{"key" => key}, socket) do
    send(self(), {:keyup, key})

    {:noreply, socket}
  end
end
