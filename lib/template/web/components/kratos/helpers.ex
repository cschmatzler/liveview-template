defmodule Template.Web.Components.Kratos.Helpers do
  @moduledoc false

  def get_node_label(node) do
    attributes = node.attributes

    case node.attributes.node_type do
      "a" ->
        attributes.title.text

      "input" ->
        get_in(attributes, [Access.key(:label), Access.key(:text)]) ||
          get_in(node.meta, [Access.key(:label), Access.key(:text)]) ||
          "Label not found for input"

      other ->
        get_in(node.meta, [Access.key(:label), Access.key(:text)]) ||
          "Label not found for #{other}"
    end
  end

  def filter_nodes_by_groups(nodes, groups, opts \\ []) do
    without_default_group = Keyword.get(opts, :without_default_group, false)
    attributes = Keyword.get(opts, :attributes, :all)
    exclude_attributes = Keyword.get(opts, :exclude_attributes, [])

    groups = if without_default_group, do: groups, else: ["default" | groups]

    nodes
    |> Enum.filter(&Enum.member?(groups, &1.group))
    |> Enum.filter(fn node ->
      attributes == :all || Enum.member?(attributes, get_node_input_type(node.attributes))
    end)
    # credo:disable-for-next-line Credo.Check.Refactor.FilterReject
    |> Enum.reject(&Enum.member?(exclude_attributes, get_node_input_type(&1.attributes)))
  end

  defp get_node_input_type(attr) do
    Map.get(attr, :type, "")
  end
end
