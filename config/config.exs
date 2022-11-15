import Config

# --------
# Database
# --------
config :leuchtturm,
  ecto_repos: [Leuchtturm.Repo]

# ---
# Web
# ---
config :leuchtturm, Leuchtturm.Web.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: Leuchtturm.Web.ErrorHTML, json: Leuchtturm.Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Leuchtturm.PubSub,
  live_view: [signing_salt: "17k0tPiq"]

# ------
# Web Assets
# ------
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.8",
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
config :leuchtturm, Leuchtturm.Mailer, adapter: Swoosh.Adapters.Local

import_config "#{config_env()}.exs"
