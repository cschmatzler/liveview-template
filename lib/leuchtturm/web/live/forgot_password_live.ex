defmodule Leuchtturm.Web.ForgotPasswordLive do
  alias Leuchtturm.Authentication
  use Leuchtturm.Web, :live_view

  import Phoenix.HTML.Form

  import Leuchtturm.Web.Components.{Form, Icons}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-full bg-ash">
      <nav class="px-4 mx-auto">
        <div class="flex justify-center items-center h-20">
          <.link href={~p"/"}>
            <.lighthouse class="block w-auto h-12 text-magenta" />
          </.link>
        </div>
      </nav>
      <div class="flex flex-col mt-6 py-12">
        <h2 class="text-center text-4xl font-light tracking-tight text-pink">
          Reset your password
        </h2>
        <div class="mt-6 px-6 sm:mx-auto sm:w-full sm:max-w-sm">
          <.form :let={f} for={:user} as={:user} phx-submit="send_password_reset">
            <div>
              <%= label(f, :email, "Email", class: "block text-sm font-medium text-gray-600") %>
              <div class="mt-1">
                <%= email_input(f, :email,
                  placeholder: "robert@leuchtturm.io",
                  class:
                    "block w-full appearance-none text-gray-900 rounded-md border border-gray-600 px-3 py-2 placeholder-gray-500 shadow-sm bg-transparent focus:border-rose focus:outline-none text-lg focus:ring-rose"
                ) %>
              </div>
              <.error form={f} field={:email} />
            </div>
            <div>
              <%= submit("Reset your password",
                class:
                  "mt-12 uppercase block w-full bg-pink text-gray-100 text-md px-2 py-3 rounded-full"
              ) %>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("send_password_reset", %{"user" => %{"email" => email}}, socket) do
    Authentication.send_password_reset_token(email)

    {:noreply, socket}
  end
end
