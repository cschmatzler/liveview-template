defmodule Template.Web.Live.Landing do
  use Template.Web, :live_view

  import Template.Web.Components

  on_mount {Template.Web.Live.Auth, :mount_user}

  @navigation_items [
    %{label: "Features", href: "/features"},
    %{label: "About", href: "/about"}
  ]

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, navigation_items: @navigation_items)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-full bg-vellum">
      <header class="absolute inset-x-0 top-0 z-10">
        <nav class="flex items-center justify-between p-6 lg:px-8" aria-label="Global">
          <div class="flex lg:flex-1">
            <a href="#" class="-m-1.5 p-1.5">
              <span class="sr-only">Template</span>
              <img
                class="h-8 w-auto"
                src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
                alt=""
              />
            </a>
          </div>

          <.login user={@user} />
          <div class="flex lg:hidden">
            <button
              type="button"
              id="sidebar-button"
              phx-click={open_sidebar()}
              class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700"
            >
              <span class="sr-only"><%= gettext("Open menu") %></span>
              <Heroicons.bars_3 class="h-6 w-6" />
            </button>
          </div>
          <.sidebar user={@user} />
        </nav>
      </header>
      <.main />
    </div>
    """
  end

  defp login(assigns) do
    ~H"""
    <div class="hidden lg:flex lg:flex-1 lg:justify-end">
      <%= if @user do %>
        <.link
          href={Template.Web.Auth.signed_in_path()}
          class="rounded-md border-moss border-2 bg-white px-3 py-1.5 text-sm font-semibold text-moss shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          <%= gettext("Dashboard") %>
        </.link>
      <% else %>
        <%= if ConfigCat.get_value("enableLogin", false) do %>
          <span class="py-1.5 text-lg font-semibold leading-7 text-moss">
            <%= gettext("Sign in with") %>
          </span>

          <div class="flex space-x-2 ml-5">
            <.link
              href={~p"/auth/google"}
              id="sign-in-google"
              class="flex justify-center rounded-md bg-white px-3 py-2 text-moss border-2 border-moss shadow-sm focus:outline-offset-0"
            >
              <span class="sr-only">Google</span>
              <.icon name="phosphor-google-logo-bold" class="h-5 w-5" />
            </.link>

            <.link
              href={~p"/auth/github"}
              id="sign-in-github"
              class="flex justify-center rounded-md bg-white px-3 py-2 text-moss border-2 border-moss shadow-sm focus:outline-offset-0"
            >
              <span class="sr-only">GitHub</span>
              <.icon name="phosphor-github-logo-bold" class="h-5 w-5" />
            </.link>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp sidebar(assigns) do
    ~H"""
    <div id="sidebar" class="hidden lg:hidden" role="dialog" aria-modal="true">
      <div id="sidebar-overlay" class="fixed inset-0 z-50 bg-gray-50/90" aria-hidden="true"></div>
      <div
        id="sidebar-content"
        phx-click-away={close_sidebar()}
        class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-blush px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-gray-900/10"
      >
        <div class="flex items-center justify-between">
          <a href="#" class="-m-1.5 p-1.5">
            <span class="sr-only">Template</span>
            <img
              class="h-8 w-auto"
              src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
              alt=""
            />
          </a>
          <button
            type="button"
            phx-click={close_sidebar()}
            class="-m-2.5 rounded-md p-2.5 text-gray-700"
          >
            <span class="sr-only"><%= gettext("Close menu") %></span>
            <Heroicons.x_mark class="h-6 w-6" />
          </button>
        </div>
        <div class="mt-6 flow-root">
          <div class="-my-6 divide-y divide-gray-500/10">
            <div>
              <%= if @user do %>
                <.link
                  href={Template.Web.Auth.signed_in_path()}
                  class="rounded-full bg-indigo-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                >
                  <%= gettext("Dashboard") %>
                </.link>
              <% else %>
                <div id="sign-in-sidebar">
                  <p class="mt-6 text-lg font-semibold leading-6 text-gray-900">Sign in with</p>
                  <div class="mt-2 grid grid-cols-3 gap-3">
                    <div>
                      <.link
                        href={~p"/auth/google"}
                        id="sign-in-sidebar-google"
                        class="flex justify-center rounded-md bg-white px-3 py-2 text-moss border-2 border-moss shadow-sm focus:outline-offset-0"
                      >
                        <span class="sr-only">Sign in with Google</span>
                        <.icon name="phosphor-google-logo-bold" class="h-6 w-6" />
                      </.link>
                    </div>

                    <div>
                      <.link
                        href={~p"/auth/github"}
                        id="sign-in-sidebar-github"
                        class="flex justify-center rounded-md bg-white px-3 py-2 text-moss border-2 border-moss shadow-sm focus:outline-offset-0"
                      >
                        <span class="sr-only">Sign in with GitHub</span>
                        <.icon name="phosphor-github-logo-bold" class="h-6 w-6" />
                      </.link>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp main(assigns) do
    ~H"""
    <div class="pt-20">
      <div class="py-48 sm:py-64 lg:pb-40">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="text-4xl font-bold tracking-tight text-moss sm:text-6xl">
            Products are more fun than landing pages.
          </h1>
          <p class="mt-6 text-lg leading-8 text-moss/80">
            ... at least for now.
          </p>
          <p class="mt-6 text-sm leading-8 text-moss/60">
            Version <%= to_string(Application.spec(:template, :vsn)) %>
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp open_sidebar(js \\ %JS{}) do
    js
    |> JS.remove_class("hidden", to: "#sidebar")
    |> JS.transition(
      {"transition ease-in-out duration-300 transform", "translate-x-full", "translate-x-0"},
      to: "#sidebar-content"
    )
  end

  defp close_sidebar(js \\ %JS{}) do
    js
    |> JS.add_class("hidden", to: "#sidebar")
    |> JS.transition(
      {"transition ease-in-out duration-300 transform", "translate-x-0", "translate-x-full"},
      to: "#sidebar-content"
    )
  end
end
