defmodule Template.MixProject do
  use Mix.Project

  def project do
    [
      app: :template,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:boundary] ++ Mix.compilers(),
      test_coverage: [tool: ExCoveralls],
      name: "LiveView Template",
      description: "An opinionated template for LiveView services.",
      docs: docs(),
      version: version(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {Template.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 0.7"},
      {:boundary, "~> 0.9", runtime: false},
      {:carbonite, "~> 0.8"},
      {:certifi, "~> 2.11"},
      {:configcat, "~> 2.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.9"},
      {:esbuild, "~> 0.7"},
      {:ex_doc, "~> 0.29", runtime: false},
      {:excoveralls, "~> 0.16", only: :test},
      {:finch, "~> 0.15"},
      {:floki, "~> 0.34", only: :test},
      {:gettext, "~> 0.22"},
      {:hammox, "~> 0.7", only: :test},
      {:heroicons, "~> 0.5"},
      {:jason, "~> 1.4"},
      {:knigge, "~> 1.4"},
      {:mix_test_interactive, "~> 1.2", only: :dev, runtime: false},
      {:oban, "~> 2.14"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 0.18"},
      {:postgrex, "~> 0.16"},
      {:remote_ip, "~> 1.1"},
      {:sentry, "~> 8.0"},
      {:sobelow, "~> 0.12", only: :test, runtime: false},
      {:swoosh, "~> 1.9"},
      {:tailwind, "~> 0.2"},
      {:ueberauth, "~> 0.10"},
      {:ueberauth_github, "~> 0.8"},
      {:ueberauth_google, "~> 0.10"}
    ]
  end

  @extras Path.wildcard("pages/**/*.md")
  defp docs do
    [
      extras: @extras
    ]
  end

  @version_file "version"
  def version do
    cond do
      File.exists?(@version_file) ->
        @version_file
        |> File.read!()
        |> String.trim()

      System.get_env("REQUIRE_VERSION_FILE") == "true" ->
        exit("Version file (`#{@version_file}`) doesn't exist but is required!")

      true ->
        "0.0.0-dev"
    end
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
