defmodule Template.Web.Components.Kratos.Code do
  @moduledoc false
  use Template.Web, :component
  import Template.Web.Components.Kratos.UINodes
  alias Template.Web.Components.Kratos.Helpers

  attr(:flow, :any, required: true)

  def code(assigns) do
    ~H"""
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["link", "code"], exclude_attributes: ["submit"])
    } />
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["link", "code"], attributes: ["submit"])
    } />
    """
  end
end
