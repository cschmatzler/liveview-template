defmodule Template.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router
  import Template.Web.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Template.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
  end

  scope "/", Template.Web do
    pipe_through :browser

    get "/", LandingController, :index
  end

  scope "/app", Template.Web do
    pipe_through :browser

    live_session :redirect_if_unauthenticated,
      on_mount: [{Template.Web.Auth, :redirect_if_unauthenticated}] do
      live "/", PageLive, :index
    end
  end

  scope "/auth", Template.Web do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/:provider", AuthController, :request
  end

  scope "/auth", Template.Web do
    pipe_through :browser

    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/session", AuthController, :logout
  end

  if Application.compile_env(:template, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
