defmodule Template.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Phoenix.Controller
  import Phoenix.LiveView.Router
  import Plug.Conn
  import Template.Web.Plugs.Auth

  alias Controllers.AuthController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Template.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :fetch_user
  end

  scope "/", Template.Web do
    pipe_through :browser

    live "/", Live.Landing, :index
  end

  scope "/app", Template.Web do
    pipe_through :browser

    live_session :app,
      on_mount: [
        {Template.Web.Live.Auth, :mount_user},
        {Template.Web.Live.Auth, :require_session}
      ] do
      live "/", PageLive, :index
    end
  end

  scope "/admin", Template.Web do
    pipe_through :browser

    live_session :admin,
      on_mount: [
        {Template.Web.Live.Auth, :mount_user},
        {Template.Web.Live.Auth, :require_admin}
      ] do
      live "/users", Live.Admin.Users, :index
    end
  end

  scope "/auth", Template.Web do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/:provider", AuthController, :request
  end

  scope "/auth", Template.Web do
    pipe_through :browser

    get "/:provider/callback", AuthController, :callback
    delete "/session", AuthController, :logout
  end

  if Application.compile_env(:template, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
