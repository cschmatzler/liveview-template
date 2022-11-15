defmodule Leuchtturm.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Telemetry
    OpentelemetryPhoenix.setup()
    OpentelemetryEcto.setup([:leuchtturm, :repo])

    children = [
      {Phoenix.PubSub, name: Leuchtturm.PubSub},
      {Finch, name: Leuchtturm.Finch},
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
end
