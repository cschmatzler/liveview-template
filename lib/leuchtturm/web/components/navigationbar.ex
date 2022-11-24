defmodule Leuchtturm.Web.Components.NavigationBar do
  use Phoenix.LiveComponent

  import Leuchtturm.Web.Components.Icons

  @impl true
  def mount(socket) do
    socket = assign(socket, menu_open?: false, profile_open?: false)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
      <div class="flex h-16">
        <div class="flex flex-grow"></div>
        <div class="flex relative justify-center items-center grow-0">
          <button type="button" phx-click="toggle_menu" phx-target={@myself}>
            <.lighthouse class="block w-auto h-12 text-rose-400" />
          </button>
          <%= if @menu_open? do %>
            <.menu />
          <% end %>
        </div>
        <div class="flex relative flex-grow justify-end items-center">
          <div class="flex justify-items-end">
            <div>
              <button
                type="button"
                phx-click="toggle_profile"
                phx-target={@myself}
                class="flex text-sm bg-gray-800 rounded-full focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800 focus:outline-none"
              >
                <span class="sr-only">Open user menu</span>
                <img
                  class="w-8 h-8 rounded-full"
                  src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=clamp&w=120&h=120&q=80"
                />
              </button>
            </div>
            <%= if @profile_open? do %>
              <.profile />
            <% end %>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  def menu(assigns) do
    ~H"""
    <div
      role="menu"
      class="flex absolute z-10 py-1 mt-36 w-96 bg-gradient-to-br from-rose-700 to-pink-500 rounded-md ring-1 ring-black ring-opacity-5 shadow-lg focus:outline-none 2"
    >
      <div class="px-4 py-6 text-white">
        Hi
      </div>
    </div>
    """
  end

  def profile(assigns) do
    ~H"""
    <div
      role="menu"
      class="absolute right-0 z-10 py-1 mt-10 w-48 bg-white rounded-md ring-1 ring-black ring-opacity-5 shadow-lg focus:outline-none"
    >
      <a href="#" class="block py-2 px-4 text-sm text-gray-700" role="menuitem" tabindex="-1">
        Your Profile
      </a>
      <a
        href="#"
        class="block py-2 px-4 text-sm text-gray-700"
        role="menuitem"
        tabindex="-1"
        id="user-menu-item-1"
      >
        Settings
      </a>
      <a
        href="#"
        class="block py-2 px-4 text-sm text-gray-700"
        role="menuitem"
        tabindex="-1"
        id="user-menu-item-2"
      >
        Sign out
      </a>
    </div>
    """
  end

  @impl true
  def update(%{:event => "toggle_menu"} = _assigns, socket) do
    socket = assign(socket, :menu_open?, !socket.assigns.menu_open?)

    {:ok, socket}
  end

  @impl true
  def update(%{:event => "toggle_profile"} = _assigns, socket) do
    socket = assign(socket, :profile_open?, !socket.assigns.profile_open?)

    {:ok, socket}
  end

  @impl true
  def update(_, socket), do: {:ok, socket}

  @impl true
  def handle_event("toggle_menu", _, socket) do
    socket = assign(socket, :menu_open?, !socket.assigns.menu_open?)

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_profile", _, socket) do
    socket = assign(socket, :profile_open?, !socket.assigns.profile_open?)

    {:noreply, socket}
  end
end
