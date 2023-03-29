import Config

# -------
# Logging
# -------
config :logger, :console, format: "[$level] $message\n", level: :debug

# -------------
# Feature Flags
# -------------
config :template, ConfigCat,
  sdk_key: "local_only",
  flag_overrides: %{
    "enableLogin" => true
  },
  flag_override_strategy: :local_only

# --------
# Database
# --------
config :template, Template.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "template_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# ---
# Web
# ---
config :template, dev_routes: true

config :template, Template.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "QO5FvhA4dGbDCsISsEv3rzECQIBYjPtnThS7ZU08B27DUcDzgvukVmFfxz/qZ19N",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/template/web/*/*.*ex$"
    ]
  ]

# ----
# Mail
# ----
config :swoosh, :api_client, false
