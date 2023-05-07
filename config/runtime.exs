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
# Prod
# ---------
if config_env() == :prod do
  host = System.get_env("HOST") || System.get_env("RENDER_EXTERNAL_HOSTNAME")

  # -------------
  # Observability
  # -------------
  config :opentelemetry,
    resource: [
      service: [
        name: "template",
        namespace: System.fetch_env!("NAMESPACE")
      ],
      host: [
        name: host
      ]
    ]

  config :opentelemetry_exporter,
    otlp_protocol: :http_protobuf,
    otlp_endpoint: "https://api.honeycomb.io:443",
    otlp_headers: [
      {"x-honeycomb-team", System.fetch_env!("HONEYCOMB_API_KEY")},
      {"x-honeycomb-dataset", "template"}
    ]

  # -------------
  # Feature Flags
  # -------------
  config :template, ConfigCat, sdk_key: System.fetch_env!("CONFIGCAT_SDK_KEY")

  # ----------
  # Clustering
  # ----------
  dns_name = System.get_env("RENDER_DISCOVERY_SERVICE")
  app_name = System.get_env("RENDER_SERVICE_NAME")

  config :libcluster,
    topologies: [
      render: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: dns_name,
          application_name: app_name
        ]
      ]
    ]

  # --------
  # Database
  # --------

  config :template, Template.Repo,
    hostname: System.fetch_env!("DB_HOST"),
    username: System.fetch_env!("DB_USERNAME"),
    password: System.fetch_env!("DB_PASSWORD"),
    database: System.fetch_env!("DB_NAME"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # ---
  # Web
  # ---
  config :template, Template.Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
    live_view: [
      signing_salt: System.fetch_env!("LIVEVIEW_SIGNING_SALT")
    ]

  # ----
  # Mail
  # ----
  config :template, Template.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: System.fetch_env!("POSTMARK_API_KEY")
end
