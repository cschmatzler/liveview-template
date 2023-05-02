defmodule Template.Web.Components do
  @moduledoc """
  Component aggregator.

  This module serves as a single entrypoint for commonly used components.
  """

  alias Template.Web.Components

  defdelegate icon(assigns), to: Components.Icon
  defdelegate card(assigns), to: Components.Card
end
