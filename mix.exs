defmodule Template.MixProject do
  use Mix.Project

  def project do
    [
      app: :template,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # compilers: [:boundary] ++ Mix.compilers(),
      compilers: Mix.compilers(),
      releases: [
        template: [
          applications: [
            template: :permanent,
            opentelemetry_exporter: :permanent,
            opentelemetry: :temporary
          ]
        ]
      ],
      test_coverage: [tool: ExCoveralls],
      name: "Opportunity",
      description: "An opinionated template for LiveView services.",
      docs: docs(),
      version: version()
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
      {:castore, "~> 1.0", override: true},
      {:carbonite, "~> 0.9"},
      {:corsica, "~> 1.3"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.9"},
      {:esbuild, "~> 0.7"},
      {:ex_doc, "~> 0.29", runtime: false},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.16", only: :test},
      {:finch, "~> 0.16"},
      {:gettext, "~> 0.22"},
      {:hammox, "~> 0.7", only: :test},
      {:jason, "~> 1.4"},
      {:knigge, "~> 1.4"},
      {:libcluster, "~> 3.3"},
      {:oban, "~> 2.14"},
      {:opentelemetry, "~> 1.3"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_ecto, "~> 1.1"},
      {:opentelemetry_exporter, "~> 1.2"},
      {:opentelemetry_finch, "~> 0.2"},
      {:opentelemetry_liveview, "~> 1.0-rc.4"},
      {:opentelemetry_oban, "~> 1.0"},
      {:opentelemetry_phoenix, "~> 1.1"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 0.18"},
      {:postgrex, "~> 0.17"},
      {:prom_ex, "~> 1.8"},
      {:remote_ip, "~> 1.1"},
      {:sobelow, "~> 0.12", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.7", only: [:dev, :test], runtime: false},
      {:swoosh, "~> 1.9"},
      {:tailwind, "~> 0.2"},
      {:tesla, "~> 1.7"},
      {:unleash, "~> 1.9"},
      {:nestru, "~> 0.3"}
    ]
  end

  defp docs do
    [
      formatters: ["html"],
      extras:
        "docs/**/*.md"
        |> Path.wildcard()
        |> Enum.reject(&(&1 =~ "template.md"))
        |> Enum.flat_map(&extract_title/1),
      groups_for_extras: [
        Infrastructure: ~r/infrastructure/,
        Architecture: ~r/architecture/,
        ADRs: ~r/decisions/
      ]
    ]
  end

  @version_file "version"
  defp version do
    cond do
      Mix.env() in [:dev, :test] ->
        "0.0.0-dev"

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

  defp extract_title(path) do
    [_, filename] = Regex.split(~r/.*\//, path)

    title =
      ~r/^(?:\d+_)?(?<title>.+)\.md$/
      |> Regex.named_captures(filename)
      |> Map.get("title")
      |> String.split("_")
      |> Enum.map_join(" ", &String.capitalize/1)

    # While `String.to_atom/1` should generally be avoided, its usage is acceptable here since it will never be called
    # while the actual application is running, and never with user-generated input.
    [{String.to_atom(path), [title: title]}]
  end
end
