defmodule Template.Web.Live.Landing do
  use Template.Web, :live_view

  alias Template.Web.Auth

  on_mount {Auth, :mount_user}

  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <header class="absolute inset-x-0 top-0 z-50">
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

          <div class="flex lg:hidden">
            <button
              type="button"
              phx-click={open_sidebar()}
              class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700"
            >
              <span class="sr-only"><%= gettext("Open main menu") %></span>
              <svg
                class="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                />
              </svg>
            </button>
          </div>

          <div class="hidden lg:flex lg:gap-x-12">
            <a href="#" class="text-sm font-semibold leading-6 text-gray-900">
              <%= gettext("About") %>
            </a>
          </div>

          <div class="hidden lg:flex lg:flex-1 lg:justify-end">
            <%= if @user do %>
              <.link
                href={Auth.signed_in_path()}
                class="rounded-full bg-indigo-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                <%= gettext("Dashboard") %>
              </.link>
            <% else %>
              <%= if ConfigCat.get_value("enableLogin", false) do %>
                <.login />
              <% end %>
            <% end %>
          </div>

          <div id="sidebar" class="hidden lg:hidden" role="dialog" aria-modal="true">
            <div id="sidebar-overlay" class="fixed inset-0 z-50 bg-gray-50/90" aria-hidden="true">
            </div>
            <div
              id="sidebar-content"
              phx-click-away={close_sidebar()}
              class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-white px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-gray-900/10"
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
                  <div class="space-y-2 py-6">
                    <a
                      href="#"
                      class="-mx-3 block rounded-lg py-2 px-3 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
                    >
                      <%= gettext("About") %>
                    </a>
                  </div>

                  <div>
                    <%= if @user do %>
                      <.link
                        href={Auth.signed_in_path()}
                        class="rounded-full bg-indigo-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                      >
                        <%= gettext("Dashboard") %>
                      </.link>
                    <% else %>
                      <div id="sign-in-sidebar">
                        <p class="mt-6 text-sm font-medium leading-6 text-gray-900">Sign in with</p>
                        <div class="mt-2 grid grid-cols-3 gap-3">
                          <div>
                            <.link
                              href={~p"/auth/google"}
                              id="sign-in-sidebar-google"
                              class="inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0"
                            >
                              <span class="sr-only">Sign in with Google</span>
                              <.google_icon />
                            </.link>
                          </div>

                          <div>
                            <.link
                              href={~p"/auth/github"}
                              id="sign-in-sidebar-github"
                              class="inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0"
                            >
                              <span class="sr-only">Sign in with GitHub</span>
                              <.github_icon />
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
        </nav>
      </header>

      <div class="relative isolate pt-14">
        <div class="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80">
          <svg
            class="relative left-[calc(50%-11rem)] -z-10 h-[21.1875rem] max-w-none -translate-x-1/2 rotate-[30deg] sm:left-[calc(50%-30rem)] sm:h-[42.375rem]"
            viewBox="0 0 1155 678"
          >
            <path
              fill="url(#9b2541ea-d39d-499b-bd42-aeea3e93f5ff)"
              fill-opacity=".3"
              d="M317.219 518.975L203.852 678 0 438.341l317.219 80.634 204.172-286.402c1.307 132.337 45.083 346.658 209.733 145.248C936.936 126.058 882.053-94.234 1031.02 41.331c119.18 108.451 130.68 295.337 121.53 375.223L855 299l21.173 362.054-558.954-142.079z"
            />
            <defs>
              <linearGradient
                id="9b2541ea-d39d-499b-bd42-aeea3e93f5ff"
                x1="1155.49"
                x2="-78.208"
                y1=".177"
                y2="474.645"
                gradientUnits="userSpaceOnUse"
              >
                <stop stop-color="#9089FC" />
                <stop offset="1" stop-color="#FF80B5" />
              </linearGradient>
            </defs>
          </svg>
        </div>
        <div class="py-48 sm:py-64 lg:pb-40">
          <div class="mx-auto max-w-7xl px-6 lg:px-8">
            <div class="mx-auto max-w-2xl text-center">
              <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
                Products are more fun than landing pages.
              </h1>
              <p class="mt-6 text-lg leading-8 text-gray-600">
                ... at least for now.
              </p>
              <p class="mt-6 text-sm leading-8 text-gray-400">
                Version <%= to_string(Application.spec(:template, :vsn)) %>
              </p>
            </div>
          </div>
        </div>
        <div class="absolute inset-x-0 top-[calc(100%-13rem)] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[calc(100%-30rem)]">
          <svg
            class="relative left-[calc(50%+3rem)] h-[21.1875rem] max-w-none -translate-x-1/2 sm:left-[calc(50%+36rem)] sm:h-[42.375rem]"
            viewBox="0 0 1155 678"
          >
            <path
              fill="url(#b9e4a85f-ccd5-4151-8e84-ab55c66e5aa1)"
              fill-opacity=".3"
              d="M317.219 518.975L203.852 678 0 438.341l317.219 80.634 204.172-286.402c1.307 132.337 45.083 346.658 209.733 145.248C936.936 126.058 882.053-94.234 1031.02 41.331c119.18 108.451 130.68 295.337 121.53 375.223L855 299l21.173 362.054-558.954-142.079z"
            />
            <defs>
              <linearGradient
                id="b9e4a85f-ccd5-4151-8e84-ab55c66e5aa1"
                x1="1155.49"
                x2="-78.208"
                y1=".177"
                y2="474.645"
                gradientUnits="userSpaceOnUse"
              >
                <stop stop-color="#9089FC" />
                <stop offset="1" stop-color="#FF80B5" />
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
    </div>
    """
  end

  defp login(assigns) do
    ~H"""
    <span class="py-1.5 text-sm font-semibold leading-6 text-gray-900">
      <%= gettext("Sign in with") %>
    </span>

    <div class="flex space-x-2 ml-5">
      <.link
        href={~p"/auth/google"}
        id="sign-in-google"
        class="flex justify-center rounded-md bg-white px-3 py-2 text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0"
      >
        <span class="sr-only">Google</span>
        <.google_icon />
      </.link>

      <.link
        href={~p"/auth/github"}
        id="sign-in-github"
        class="flex justify-center rounded-md bg-white px-3 py-2 text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0"
      >
        <span class="sr-only">GitHub</span>
        <.github_icon />
      </.link>
    </div>
    """
  end

  defp google_icon(assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 190 190" aria-hidden="true">
      <g transform="translate(1184.583 765.171)">
        <path
          clip-path="none"
          mask="none"
          d="M-1089.333-687.239v36.888h51.262c-2.251 11.863-9.006 21.908-19.137 28.662l30.913 23.986c18.011-16.625 28.402-41.044 28.402-70.052 0-6.754-.606-13.249-1.732-19.483z"
          fill="#4285f4"
        /><path
          clip-path="none"
          mask="none"
          d="M-1142.714-651.791l-6.972 5.337-24.679 19.223h0c15.673 31.086 47.796 52.561 85.03 52.561 25.717 0 47.278-8.486 63.038-23.033l-30.913-23.986c-8.486 5.715-19.31 9.179-32.125 9.179-24.765 0-45.806-16.712-53.34-39.226z"
          fill="#34a853"
        /><path
          clip-path="none"
          mask="none"
          d="M-1174.365-712.61c-6.494 12.815-10.217 27.276-10.217 42.689s3.723 29.874 10.217 42.689c0 .086 31.693-24.592 31.693-24.592-1.905-5.715-3.031-11.776-3.031-18.098s1.126-12.383 3.031-18.098z"
          fill="#fbbc05"
        /><path
          d="M-1089.333-727.244c14.028 0 26.497 4.849 36.455 14.201l27.276-27.276c-16.539-15.413-38.013-24.852-63.731-24.852-37.234 0-69.359 21.388-85.032 52.561l31.692 24.592c7.533-22.514 28.575-39.226 53.34-39.226z"
          fill="#ea4335"
          clip-path="none"
          mask="none"
        />
      </g>
    </svg>
    """
  end

  defp github_icon(assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
      <path
        fill-rule="evenodd"
        d="M10 0C4.477 0 0 4.484 0 10.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0110 4.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.203 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.942.359.31.678.921.678 1.856 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0020 10.017C20 4.484 15.522 0 10 0z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  defp open_sidebar(js \\ %JS{}) do
    js
    |> JS.show(to: "#sidebar")
    |> JS.show(to: "#sidebar-overlay")
    |> JS.show(
      to: "#sidebar-content",
      transition:
        {"transition-all transform ease-out duration-300", "translate-x-20", "translate-x-0"}
    )
  end

  defp close_sidebar(js \\ %JS{}) do
    js
    |> JS.hide(to: "#sidebar-content")
    |> JS.hide(to: "#sidebar-overlay")
    |> JS.hide(to: "#sidebar")
  end
end
