defmodule Leuchtturm.Web.Router do
  @moduledoc false
  alias Leuchtturm.Web.Utilities.Authentication

  use Phoenix.Router, helpers: false

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  import Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Leuchtturm.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_logged_in_user
  end

  scope "/", Leuchtturm.Web do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{Authentication, :redirect_if_user_is_authenticated}] do
      live "/register/", RegistrationLive, :new
    end

    post "/login", SessionController, :create
  end

  scope "/", Leuchtturm.Web do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/dev" do
    pipe_through :browser

    forward "/mailbox", Plug.Swoosh.MailboxPreview
  end
end
