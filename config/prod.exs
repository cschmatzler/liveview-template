import Config

# -------------
# Observability
# -------------
config :logger, level: :info

config :opentelemetry,
  span_processor: :batch,
  exporter: :otlp,
  sampler: {:parent_based, %{root: {:trace_id_ratio_based, 0.1}}}

# ---
# Web
# ---
config :template, Template.Web.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"
