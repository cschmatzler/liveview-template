defmodule Template.Web.Components.Kratos.UINodes do
  @moduledoc false
  use Template.Web, :component

  import Template.Web.Components.Field

  alias Template.Web.Components.Kratos.Helpers

  attr(:nodes, :list)

  def ui_nodes(assigns) do
    ~H"""
    <%= for node <- @nodes do %>
      <.ui_node node={node} />
    <% end %>
    """
  end

  defp ui_node(%{node: %{attributes: %{node_type: "text"}}} = assigns) do
    ~H"""
    <%= @node.meta.label.text %>
    <code><%= @node.attributes.text.text %></code>
    """
  end

  defp ui_node(%{node: %{attributes: %{node_type: "input"}}} = assigns) do
    ~H"""
    <.field
      id={@node.attributes.name}
      type={@node.attributes.type}
      name={@node.attributes.name}
      value={@node.attributes.value}
      label={Helpers.get_node_label(@node)}
      errors={Enum.map(@node.messages, & &1.text)}
    />
    """
  end

  defp ui_node(%{node: %{attributes: %{node_type: "a"}}} = assigns) do
    ~H"""
    <a href={@node.attributes.href}><%= Helpers.get_node_label(@node) %></a>
    """
  end

  defp ui_node(%{node: %{attributes: %{node_type: "img"}}} = assigns) do
    ~H"""
    <img src={@node.attributes.src} />
    """
  end

  defp ui_node(assigns) do
    ~H"""
    <%= @node.attributes.node_type %> to implement
    """
  end
end
