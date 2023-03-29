defmodule Template.Application do
  @moduledoc false

  use Boundary, deps: [Template.Repo, Template.Web], top_level?: true
  use Application

  @impl true
  def start(_type, _args) do
    start_telemetry()

    children = [
      {Phoenix.PubSub, name: Template.PubSub},
      {Finch, name: Template.Finch},
      Template.Repo,
      {ConfigCat, configcat_config()},
      {Oban, Application.fetch_env!(:template, Oban)},
      Template.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Template.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Template.Web.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_telemetry do
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:template, :repo])
    OpentelemetryOban.setup()
  end

  defp configcat_config do
    config = Application.fetch_env!(:template, ConfigCat)

    Keyword.put(
      config,
      :flag_overrides,
      ConfigCat.LocalMapDataSource.new(config[:flag_overrides], config[:flag_override_strategy])
    )
  end
end
