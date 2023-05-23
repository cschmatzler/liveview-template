defmodule Template.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Phoenix.Controller, only: [accepts: 2, protect_from_forgery: 2, put_root_layout: 2]
  import Phoenix.LiveView.Router, only: [live: 4, fetch_live_flash: 2]
  import Plug.Conn, only: [merge_private: 2, fetch_session: 2]
  import Template.Web.Plugs.Auth, only: [verify_session: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Template.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :verify_session
  end

  scope "/", Template.Web.Pages do
    pipe_through :browser

    live "/", Landing, :index, as: :landing
  end

  scope "/auth", Template.Web.Pages.Auth do
    pipe_through :browser

    get "/registration", Registration, :index
    get "/verification", Verification, :index
    get "/login", Login, :index
    get "/error", Error, :index
  end

  # scope "/admin", Template.Web do
  #   pipe_through :browser
  #
  #   live_session :admin,
  #     on_mount: [
  #       {Template.Web.Live.Auth, :mount_user},
  #       {Template.Web.Live.Auth, :require_admin}
  #     ] do
  #     live "/users", Live.Admin.Users, :index
  #   end
  # end
  #
  if Application.compile_env(:template, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
