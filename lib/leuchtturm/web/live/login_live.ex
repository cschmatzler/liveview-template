defmodule Leuchtturm.Web.LoginLive do
  alias Leuchtturm.Authentication
  alias Leuchtturm.Authentication.User

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
          Login
        </h2>
        <.link navigate={~p"/register"}>Register instead</.link>
        <div class="mt-6 px-6 sm:mx-auto sm:w-full sm:max-w-sm">
          <.form
            :let={f}
            for={:user}
            as={:user}
            action={~p"/login?_action=register"}
            method="post"
            class="space-y-6"
          >
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
              <%= label(f, :password, "Password", class: "block text-sm font-medium text-gray-600") %>
              <div class="mt-1">
                <%= password_input(f, :password,
                  placeholder: "employed food affirm",
                  value: input_value(f, :password),
                  class:
                    "block w-full appearance-none text-gray-900 rounded-md border border-gray-600 px-3 py-2 placeholder-gray-500 shadow-sm bg-transparent focus:border-rose focus:outline-none text-lg focus:ring-rose"
                ) %>
                <.error form={f} field={:password} />
              </div>
            </div>
            <div>
              <%= submit("Login",
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
end
