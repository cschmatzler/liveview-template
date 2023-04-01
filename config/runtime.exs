import Config

if System.get_env("ENABLE_SERVER") do
  config :template, Template.Web.Endpoint, server: true
end

# -----
# OAuth
# -----
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

# ---------
# Production
# ---------
if config_env() == :prod do
  # -------------
  # Observability
  # -------------
  config :sentry,
    dsn: System.get_env("SENTRY_DSN")

  # -------------
  # Feature Flags
  # -------------
  configcat_sdk_key = System.fetch_env!("CONFIGCAT_SDK_KEY")
  config :template, ConfigCat, sdk_key: configcat_sdk_key

  # --------
  # Database
  # --------
  database_url = System.fetch_env!("DATABASE_URL")

  config :template, Template.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # ---
  # Web
  # ---
  host = System.get_env("HOST") || System.get_env("RENDER_EXTERNAL_HOSTNAME")
  port = String.to_integer(System.get_env("PORT") || "4000")
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

  config :template, Template.Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      port: port
    ],
    secret_key_base: secret_key_base

  # ----
  # Mail
  # ----
  config :template, Template.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: System.fetch_env!("POSTMARK_API_KEY")
end
