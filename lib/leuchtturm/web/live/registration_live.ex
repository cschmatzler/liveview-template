defmodule Leuchtturm.Web.RegistrationLive do
  alias Leuchtturm.Authentication
  alias Leuchtturm.Authentication.User

  use Leuchtturm.Web, :live_view

  import Phoenix.HTML.Form

  import Leuchtturm.Web.Components.{Form, Icons}

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
          Create your account
        </h2>
        <div class="mt-6 px-6 sm:mx-auto sm:w-full sm:max-w-sm">
          <.form
            :let={f}
            for={@registration_changeset}
            phx-change="validate"
            phx-submit="save"
            phx-trigger-action={@trigger_submit}
            action={~p"/login?_action=register"}
            method="post"
            class="space-y-6"
          >
            <div>
              <%= label(f, :name, "Name", class: "block text-sm font-medium text-gray-600") %>
              <div class="mt-1">
                <%= text_input(f, :name,
                  placeholder: "Robert Stevenson",
                  autocomplete: "name",
                  class:
                    "block w-full appearance-none text-gray-900 rounded-md border border-gray-600 px-3 py-2 placeholder-gray-500 shadow-sm bg-transparent focus:border-rose focus:outline-none text-lg focus:ring-rose"
                ) %>
              </div>
              <.error form={f} field={:name} />
            </div>
            <div>
              <%= label(f, :email, "Email", class: "block text-sm font-medium text-gray-600") %>
              <div class="mt-1">
                <%= email_input(f, :email,
                  placeholder: "you@leuchtturm.io",
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
                  class:
                    "block w-full appearance-none text-gray-900 rounded-md border border-gray-600 px-3 py-2 placeholder-gray-500 shadow-sm bg-transparent focus:border-rose focus:outline-none text-lg focus:ring-rose"
                ) %>
                <.error form={f} field={:password} />
              </div>
            </div>
            <div>
              <%= submit("Complete sign up",
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
  def mount(_params, _url, socket) do
    socket =
      assign(socket,
        trigger_submit: false,
        registration_changeset: Authentication.registration_changeset(%User{})
      )

    {:ok, socket, temporary_assigns: [changeset: nil]}
  end

  @impl true
  def handle_event("validate", %{"user" => attrs}, socket) do
    changeset =
      Authentication.registration_changeset(%User{}, attrs)
      |> Map.put(:action, :validate)

    socket = assign(socket, registration_changeset: changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"user" => attrs}, socket) do
    case Authentication.register(attrs) do
      {:ok, user} ->
        changeset = Authentication.registration_changeset(user)
        socket = assign(socket, trigger_submit: true, registration_changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, registration_changeset: changeset)

        {:noreply, socket}

      :error ->
        # TODO: handle server errors
        {:noreply, socket}
    end
  end
end
