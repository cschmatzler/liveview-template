defmodule Template.Web.Components.Kratos.FlowForm do
  @moduledoc false
  use Template.Web, :component
  import Template.Web.Components.Helpers
  import Template.Web.Components.Kratos.UINodes
  alias Template.Web.Components.Kratos.Helpers

  attr(:flow, :any, required: true)
  attr(:class, :string, default: nil)

  slot(:inner_block, required: true)

  def flow_form(assigns) do
    ~H"""
    <form action={@flow.ui.action} method={@flow.ui.method} class={build_class(["space-y-6", @class])}>
      <.ui_nodes nodes={
        Helpers.filter_nodes_by_groups(@flow.ui.nodes, ["default"], attributes: ["hidden"])
      } />
      <%= render_slot(@inner_block) %>
    </form>
    """
  end
end
