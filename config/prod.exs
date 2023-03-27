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
