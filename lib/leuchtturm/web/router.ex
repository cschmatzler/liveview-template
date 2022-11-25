defmodule Leuchtturm.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  import Leuchtturm.Web.Plugs.Authentication

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

    live_session :redirect_if_user_is_authenticated do
    #   on_mount: [{anthillweb.userauth, :redirect_if_user_is_authenticated}] do
        live "/register/", RegistrationLive, :new
        live "/register/:step", RegistrationLive, :new
    #   live "/users/log_in", userloginlive, :new
    #   live "/users/reset_password", userforgotpasswordlive, :new
    #   live "/users/reset_password/:token", userresetpasswordlive, :edit
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
