defmodule Template.Web.Components do
  alias Template.Web.Components

  defdelegate card(assigns), to: Components.Card
end
