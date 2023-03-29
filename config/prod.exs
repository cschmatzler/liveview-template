import Config

# -------
# Logging
# -------
config :logger, level: :info

# -------------
# Feature Flags
# -------------
config :template, ConfigCat,
  flag_overrides: %{},
  flag_override_strategy: :remote_over_local

# ---
# Web
# ---
config :template, Template.Web.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"
