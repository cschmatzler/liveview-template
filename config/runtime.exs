import Config

if System.get_env("ENABLE_SERVER") do
  config :leuchtturm, Leuchtturm.Web.Endpoint, server: true
end

# ---------
# Production
# ---------
if config_env() == :prod do
  # --------
  # Database
  # --------
  database_url = System.fetch_env!("DATABASE_URL")

  config(:leuchtturm, Leuchtturm.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
  )

  # ---
  # Web
  # ---
  host = System.get_env("HOST") || "leuchtturm.io"
  port = String.to_integer(System.get_env("PORT") || "4000")
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

  config :leuchtturm, Leuchtturm.Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ----
  # Mail
  # ----
  config :leuchtturm, Leuchtturm.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: System.fetch_env!("POSTMARK_API_KEY")
end
