import Config

# -------
# Logging
# -------
config :logger, level: :info

# -------------
# Feature Flags
# -------------
config :template, ConfigCat, enabled?: true

# ---
# Web
# ---
config :template, Template.Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"
