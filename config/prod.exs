import Config

# -------
# Logging
# -------
config :logger, level: :info

# ---
# Web
# ---
config :leuchtturm, Leuchtturm.Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# ------
# Mailer
# ------
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Leuchtturm.Finch

# -----
# Other
# -----
config :argon2_elixir, t_cost: 16, m_cost: 16
