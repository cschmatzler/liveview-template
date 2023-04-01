defmodule Template.Web do
  @moduledoc """
  Entry point for modules implementing web-related features.

  Provides a `use` macro taking one parameter specifying what the module is/needs.
  """

  use Boundary, deps: [Template.Auth], exports: [Endpoint], top_level?: true

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: Template.Web,
        formats: [:html, :json],
        layouts: [html: Template.Web.Layouts]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {Template.Web.Layouts, :app},
        container: {:div, class: "h-full"}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Template.Web.Endpoint,
        router: Template.Web.Router,
        statics: Template.Web.static_paths()
    end
  end

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  defp html_helpers do
    quote do
      import Phoenix.HTML
      import Template.Web.Gettext

      alias Phoenix.LiveView.JS

      unquote(verified_routes())
    end
  end
end
