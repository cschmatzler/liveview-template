defmodule Template.Application do
  @moduledoc """
  Main entrypoint for the service.
  """

  use Boundary, deps: [Template.Repo, Template.Web], top_level?: true
  use Application

  @impl Application
  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      {ConfigCat, configcat_config()},
      {Phoenix.PubSub, name: Template.PubSub},
      {Finch, name: Template.Finch},
      Template.Repo,
      {Oban, Application.fetch_env!(:template, Oban)},
      Template.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Template.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    Template.Web.Endpoint.config_change(changed, removed)
    :ok
  end

  defp configcat_config do
    config = Application.fetch_env!(:template, ConfigCat)

    local_datasource =
      ConfigCat.LocalMapDataSource.new(config[:flag_overrides], config[:flag_override_strategy])

    Keyword.put(config, :flag_overrides, local_datasource)
  end
end
