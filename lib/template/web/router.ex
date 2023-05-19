defmodule Template.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Phoenix.Controller
  import Phoenix.LiveView.Router
  import Plug.Conn
  import Template.Web.Plugs.Auth

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

  scope "/auth", Template.Web.Pages.Auth do
    pipe_through :browser

    live "/login", Login, :index, as: :login
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

  if Application.compile_env(:template, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
