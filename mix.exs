defmodule Leuchtturm.MixProject do
  use Mix.Project

  def project do
    [
      app: :leuchtturm,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        leuchtturm: [
          applications: [opentelemetry_exporter: :permanent, opentelemetry: :temporary]
        ]
      ]
    ]
  end

  def application do
    [
      mod: {Leuchtturm.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Web
      {:finch, "~> 0.13"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.6"},
      # TODO: Remove this override once Phoenix 1.7 is released
      {:phoenix, "~> 1.7.0-rc.0", override: true},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.18"},
      {:heroicons, "~> 0.5"},
      # Database
      {:ecto_sql, "~> 3.9"},
      {:postgrex, "~> 0.16"},
      {:phoenix_ecto, "~> 4.4"},
      # Telemetry
      {:certifi, "~> 2.10"},
      # This needs to be above the other OpenTelemetry dependencies
      {:opentelemetry_exporter, "~> 1.1"},
      {:opentelemetry, "~> 1.1"},
      {:opentelemetry_api, "~> 1.1"},
      {:opentelemetry_phoenix, "~> 1.0"},
      {:opentelemetry_liveview, "~> 1.0.0-rc"},
      {:opentelemetry_ecto, "~> 1.0"},
      # Mail
      {:swoosh, "~> 1.3"},
      # Other (production)
      {:argon2_elixir, "~> 3.0"},
      {:gettext, "~> 0.20"},
      {:uniq, "~> 0.5"},
      # Development helpers
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2", only: :dev, runtime: false},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # Build tools
      {:esbuild, "~> 0.5", only: [:dev, :prod], runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", only: [:dev, :prod], runtime: Mix.env() == :dev},
      # Test helpers
      {:floki, "~> 0.34", only: :test}
    ]
  end

  defp aliases do
    [
      # TODO: Revisit this
      # NOTE: Replace with just?
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
