defmodule Template.Web.Components.Helpers do
  @moduledoc false

  def build_class(list, joiner \\ " ")
  def build_class([], _joiner), do: ""

  def build_class(list, joiner) when is_list(list) do
    list
    |> join_non_empty_list(joiner, [])
    |> :lists.reverse()
    |> IO.iodata_to_binary()
  end

  # Remove joiner (if present), since our last element was empty and isn't added
  defp join_non_empty_list([""], joiner, [joiner | acc]), do: acc
  defp join_non_empty_list([nil], joiner, [joiner | acc]), do: acc
  defp join_non_empty_list([""], _joiner, acc), do: acc
  defp join_non_empty_list([nil], _joiner, acc), do: acc
  defp join_non_empty_list([first], _joiner, acc), do: [entry_to_string(first) | acc]

  # Don't append empty string to our class list
  defp join_non_empty_list(["" | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, acc)
  end

  defp join_non_empty_list([nil | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, acc)
  end

  defp join_non_empty_list([first | rest], joiner, acc) do
    join_non_empty_list(rest, joiner, [joiner, entry_to_string(first) | acc])
  end

  # Trim the input string
  defp entry_to_string(entry) when is_binary(entry), do: String.trim(entry)
  defp entry_to_string(entry), do: String.trim(String.Chars.to_string(entry))
end
