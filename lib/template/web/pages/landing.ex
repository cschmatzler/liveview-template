defmodule Template.Web.Pages.Landing do
  @moduledoc false
  use Template.Web, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-full bg-vellum">
      <%= @cookie_header %>
      <p>
        <%= Kratos.Frontend.create_logout_flow(@cookie_header) |> elem(1) |> Map.get(:logout_url) %>
      </p>
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
