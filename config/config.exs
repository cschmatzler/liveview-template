import Config

# -------------
# Observability
# -------------
config :sentry,
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()],
  client: Sentry.FinchClient

# -------------
# Feature Flags
# -------------
config :template, ConfigCat, data_governance: :eu_only

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
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, mail: 10]

# ---
# Web
# ---
config :template, Template.Web.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: Template.Web.ErrorHTML, json: Template.Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Template.PubSub,
  live_view: [signing_salt: "17k0tPiq"]

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
  version: "0.17.13",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# ----
# Mail
# ----
config :template, Template.Mailer, adapter: Swoosh.Adapters.Local

import_config "#{config_env()}.exs"
