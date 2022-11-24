defmodule Leuchtturm.Web.Components.Keyboard do
  alias Leuchtturm.Web.Components.NavigationBar
  use Phoenix.LiveComponent

  @global_shortcuts %{
    "m" => {NavigationBar, "navigation_bar", "toggle_menu"},
    "p" => {NavigationBar, "navigation_bar", "toggle_profile"}
  }

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="flex"
      id={"#{@id}"}
      phx-hook="Keyboard"
      data-keydown-enabled="true"
      data-keyup-enabled="false"
      data-target={@myself}
    >
    </div>
    """
  end

  @impl true
  def handle_event("keydown", %{"key" => key}, socket) do
    if event = Map.get(@global_shortcuts, key) do
      {module, id, event} = event
      send_update(module, id: id, event: event)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("keydown", _, socket), do: {:noreply, socket}
  @impl true
  def handle_event("keyup", _, socket), do: {:noreply, socket}
end
