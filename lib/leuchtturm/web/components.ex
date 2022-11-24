defmodule Leuchtturm.Web.Components do
  alias Leuchtturm.Web.Components

  defdelegate card(assigns), to: Components.Card
end
