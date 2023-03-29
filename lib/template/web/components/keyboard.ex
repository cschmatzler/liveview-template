defmodule Template.Web.Components.Keyboard do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div
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
  def handle_event("keydown", %{"key" => _key}, socket), do: {:noreply, socket}

  @impl true
  def handle_event("keydown", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("keyup", _, socket), do: {:noreply, socket}
end
