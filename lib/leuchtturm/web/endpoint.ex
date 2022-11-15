defmodule Leuchtturm.Web.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :leuchtturm

  @session_options [
    store: :cookie,
    key: "_leuchtturm_key",
    signing_salt: "S8DoleIF",
    same_site: "Strict"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :leuchtturm,
    gzip: true,
    only: Leuchtturm.Web.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Leuchtturm.Web.Router
end
