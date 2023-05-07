defmodule Template.Metrics do
  @moduledoc false

  use Boundary, top_level?: true
  use PromEx, otp_app: :template

  alias PromEx.Plugins

  @impl true
  def plugins do
    [
      Plugins.Application,
      Plugins.Beam,
      {Plugins.Phoenix, router: Template.Web.Router, endpoint: Template.Web.Endpoint},
      Plugins.Ecto,
      Plugins.Oban,
      Plugins.PhoenixLiveView,
    ]
  end
end
