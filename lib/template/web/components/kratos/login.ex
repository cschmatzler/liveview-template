defmodule Template.Web.Components.Kratos.Login do
  @moduledoc false
  use Template.Web, :component
  import Template.Web.Components.Kratos.UINodes
  alias Template.Web.Components.Kratos.Helpers

  attr(:flow, :any, required: true)

  def login(assigns) do
    ~H"""
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["password"],
        exclude_attributes: ["submit", "hidden"]
      )
    } />
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["password"], attributes: ["submit"])
    } />
    """
  end
end
