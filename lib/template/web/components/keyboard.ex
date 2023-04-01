defmodule Template.Web.Components.KeyboardHandler do
  @moduledoc """
  Component for handling keyboard events.
  """

  use Template.Web, :live_component

  @impl Phoenix.LiveComponent
  def render(assigns) do
    assigns =
      assigns
      |> assign_new(:keydown_enabled, fn -> "false" end)
      |> assign_new(:keyup_enabled, fn -> "false" end)

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
  def handle_event(
        "keydown",
        %{"key" => key},
        socket
      ) do
    send(self(), {:keydown, key})

    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("keyup", _, socket), do: {:noreply, socket}
end
