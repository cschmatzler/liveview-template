import Config

# -------
# Logging
# -------
config :logger, level: :warning

# -------------
# Feature Flags
# -------------
config :leuchtturm, ConfigCat, enabled?: false

# --------
# Database
# --------
config :leuchtturm, Leuchtturm.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "leuchtturm_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# ---
# Web
# ---
config :leuchtturm, Leuchtturm.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "psMlmgXsUK7hJMaoJWZXzSHrbTLdJeBS3Cn+LEoMueyEt78DJtPA5G9dkvoxpBku",
  server: false

# ----
# Jobs
# ----
config :leuchtturm, Oban, testing: :inline

# ----
# Mail
# ----
config :leuchtturm, Leuchtturm.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
