defmodule Template.Web.Components.Kratos.OIDC do
  @moduledoc false

  use Template.Web, :component
  import Template.Web.Components.Kratos.UINodes
  alias Template.Web.Components.Kratos.Helpers

  attr(:flow, :any, required: true)

  def oidc(assigns) do
    ~H"""
      <.ui_nodes nodes={
        Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["oidc"],
          without_default_group: true,
          exclude_attributes: ["submit"]
        )
      } />
      <.ui_nodes nodes={
        Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["oidc"], attributes: ["submit"])
      } />
    """
  end
end
