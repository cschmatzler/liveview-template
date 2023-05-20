defmodule Template.Web.Pages.Landing do
  @moduledoc false
  use Template.Web, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-full bg-vellum">
      <header class="absolute inset-x-0 top-0 z-10">
        <nav class="flex items-center justify-between p-6 lg:px-8" aria-label="Global">
          <div class="flex lg:flex-1">
            <a href="#" class="-m-1.5 p-1.5">
              <span class="sr-only">Template</span>
              <%!-- <img --%>
              <%!--   class="h-8 w-auto" --%>
              <%!--   src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600" --%>
              <%!--   alt="" --%>
              <%!-- /> --%>
            </a>
          </div>
        </nav>
      </header>
      <.main />
    </div>
    """
  end

  defp main(assigns) do
    ~H"""
    <div class="pt-20">
      <div class="py-48 sm:py-64 lg:pb-40">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="text-4xl font-bold tracking-tight text-moss sm:text-6xl">
            Stuff.
          </h1>
          <p class="mt-6 text-lg leading-8 text-moss/80">
            ... or something.
          </p>

          <p class="mt-6 text-sm leading-8 text-moss/60">
            Version <%= to_string(Application.spec(:template, :vsn)) %>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
