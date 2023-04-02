import Config

# -------
# Logging
# -------
config :logger, level: :warning

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
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "template_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# ---
# Web
# ---
config :template, Template.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "psMlmgXsUK7hJMaoJWZXzSHrbTLdJeBS3Cn+LEoMueyEt78DJtPA5G9dkvoxpBku",
  server: false

# ----
# Jobs
# ----
config :template, Oban, testing: :inline

# ----
# Mail
# ----
config :template, Template.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
