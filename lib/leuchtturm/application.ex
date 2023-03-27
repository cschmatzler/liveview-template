defmodule Leuchtturm.Application do
  @moduledoc false

  use Boundary, deps: [Leuchtturm.Web], exports: []
  use Application

  @impl true
  def start(_type, _args) do
    start_telemetry()

    children = [
      {Phoenix.PubSub, name: Leuchtturm.PubSub},
      {Finch, name: Leuchtturm.Finch},
      Leuchtturm.Repo,
      {Oban, Application.fetch_env!(:leuchtturm, Oban)},
      Leuchtturm.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Leuchtturm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Leuchtturm.Web.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_telemetry do
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:leuchtturm, :repo])
    OpentelemetryOban.setup()
  end
end
