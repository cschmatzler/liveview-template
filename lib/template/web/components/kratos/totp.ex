defmodule Template.Web.Components.Kratos.TOTP do
  @moduledoc false
  use Template.Web, :component

  import Template.Web.Components.Kratos.UINodes

  alias Template.Web.Components.Kratos.Helpers

  attr(:flow, :any, required: true)

  def totp(assigns) do
    ~H"""
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["totp"],
        without_default_group: true,
        exclude_attributes: ["submit"]
      )
    } />
    <.ui_nodes nodes={
      Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["totp"], attributes: ["submit"])
    } />
    """
  end
end
