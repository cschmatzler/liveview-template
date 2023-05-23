defmodule Template.Web.Components.Kratos.UINodes do
  @moduledoc false

  use Template.Web, :component

  def ui_nodes(assigns) do
    ~H"""
    <%= for node <- @nodes do %>
      <.ui_node node={node} />
    <% end %>
    """
  end

  defp ui_node(%{node: %{attributes: %{type: "submit"}}} = assigns) do
    ~H"""
    <div class="input-social-button">
      <button
        class="button"
        onclick={@node.attributes.onclick}
        name={@node.attributes.name}
        type={@node.attributes.type}
        value={@node.attributes.value}
      >
        <div class="button-text"><%= @node.attributes.name %></div>
      </button>
    </div>
    """
  end

  defp ui_node(assigns) do
    ~H"""
    <%= @node.attributes %> to implement
    """
  end
end
