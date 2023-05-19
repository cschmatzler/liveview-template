defmodule Template.Application do
  @moduledoc """
  Main entrypoint for the service.
  """

  use Boundary, deps: [Template.Repo, Template.Web], top_level?: true
  use Application

  @impl Application
  def start(_type, _args) do
    OpentelemetryEcto.setup([:template, :repo])
    OpentelemetryOban.setup(trace: [:jobs])
    OpentelemetryFinch.setup()
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()

    children = [
      {Cluster.Supervisor,
       [
         Application.fetch_env!(:libcluster, :topologies),
         [name: Template.ClusterSupervisor]
       ]},
      {Phoenix.PubSub, name: Template.PubSub},
      {Finch, name: Template.Finch},
      Template.Repo,
      {Oban, Application.fetch_env!(:template, Oban)},
      Template.Web.Endpoint,
      Template.Metrics
    ]

    opts = [strategy: :one_for_one, name: Template.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    Template.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
