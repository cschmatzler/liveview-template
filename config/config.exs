import Config

# -------------
# Feature Flags
# -------------
config :template, ConfigCat, data_governance: :eu_only

# ----------
# Clustering
# ----------
config :libcluster, topologies: []

# --------
# Database
# --------
config :template,
  ecto_repos: [Template.Repo]

# ----
# Jobs
# ----
config :template, Oban,
  repo: Template.Repo,
  prefix: "jobs",
  plugins: [Oban.Plugins.Pruner, {Oban.Plugins.Reindexer, schedule: "@weekly"}],
  queues: [default: 10, mail: 10]

# ---
# Web
# ---
config :template, Corsica, origins: "*", allow_headers: :all

config :template, Template.Web.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: Template.PubSub,
  render_errors: [
    formats: [html: Template.Web.ErrorHTML, json: Template.Web.ErrorJSON],
    layout: false
  ]

# --------------
# Authentication
# --------------
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []},
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

# ------
# Web Assets
# ------
config :esbuild,
  version: "0.17.16",
  default: [
    args:
      ~w(js/app.js css/manrope.css --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --loader:.woff2=file),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.3.1",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/css/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
