defmodule Leuchtturm.Web.RegistrationLive do
  alias Leuchtturm.Authentication.User
  alias Leuchtturm.Authentication

  use Leuchtturm.Web, :live_view

  import Phoenix.HTML.Form

  import Leuchtturm.Web.Components.Icons

  def mount(_params, _url, socket) do
    socket = assign(socket, :changeset, User.registration_changeset(%User{}, %{}))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="h-full">
      <nav class="px-4 mx-auto">
        <div class="flex justify-center items-center h-16">
          <.link href={~p"/"}>
            <.lighthouse class="block w-auto h-12 text-rose-400" />
          </.link>
        </div>
      </nav>
      <div class="flex flex-col justify-center items-center min-h-full">
        <.form :let={f} for={@changeset}>
          <%= text_input f, :name %>
          <%= @step %>
        </.form>
      </div>
    </div>
    """
  end

  def render_step(0, assigns) do
    ~H"""
    Step zero!
    """
  end

  def render_step(1, assigns) do
    ~H"""
    Step one
    """
  end

  @impl true
  def handle_params(%{"step" => step}, _uri, socket) when step in ["name", "email", "password"] do
    socket = assign(socket, :step, step)

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket = push_patch(socket, to: ~p"/register/name")

    {:noreply, socket}
  end
end
