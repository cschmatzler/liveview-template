defmodule Template.Web.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :template

  @session_options [
    store: :cookie,
    key: "_session",
    signing_salt: "S8DoleIF",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [
      connect_info: [
        session: @session_options
      ]
    ]

  plug Plug.Static,
    at: "/",
    from: :template,
    gzip: true,
    only: Template.Web.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug PromEx.Plug, prom_ex_module: Template.PromEx
  plug RemoteIp, headers: ["cf-connecting-ip", "x-forwarded-for"]
  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head
  plug Template.Web.Plugs.ContentSecurityPolicy
  plug Template.Web.Plugs.CORS
  plug Plug.Session, @session_options
  plug Template.Web.Router
end
