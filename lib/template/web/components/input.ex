defmodule Template.Web.Components.Input do
  @moduledoc false
  use Template.Web, :component

  import Template.Web.Components.Helpers

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string
  attr :value, :any
  attr :type, :string, default: "text", values: ~w(submit text)
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w()

  def input(%{type: "submit"} = assigns) do
    ~H"""
    <input
      id={@id}
      type="submit"
      name={@name}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      class={
        build_class([
          "rounded-full bg-indigo-600 px-3 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600",
          @class
        ])
      }
      {@rest}
    />
    """
  end

  def input(assigns) do
    ~H"""
    <input
      id={@id}
      type={@type}
      name={@name}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      class={@class}
      {@rest}
    />
    """
  end
end
