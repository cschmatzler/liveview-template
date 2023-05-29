defmodule Template.Web.Components.Field do
  @moduledoc false
  use Template.Web, :component

  import Template.Web.Components.Helpers

  attr(:id, :any, default: nil)
  attr(:type, :string, default: "text", values: ~w(submit text))
  attr(:name, :any)
  attr(:value, :any)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  attr(:label, :string)
  attr(:label_class, :string, default: nil)
  attr(:errors, :list, default: [])

  def field(%{type: "hidden"} = assigns) do
    ~H"""
    <input
      id={@id}
      type={@type}
      name={@name}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
    />
    """
  end

  def field(%{type: "submit"} = assigns) do
    ~H"""
    <button
      id={@id}
      type={@type}
      name={@name}
      value={@value}
      class={
        build_class(
          [
            "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          ],
          @class
        )
      }
    >
      <%= @label %>
    </button>
    """
  end

  def field(assigns) do
    ~H"""
    <div>
      <.field_label for={@id} class={@label_class}><%= @label %></.field_label>
      <input
        id={@id}
        type={@type}
        name={@name}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={
          build_class([
            "block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6",
            @class
          ])
        }
        {@rest}
      />
      <.field_error :for={error <- @errors}><%= error %></.field_error>
    </div>
    """
  end

  attr(:for, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_label(assigns) do
    ~H"""
    <label
      for={@for}
      class={build_class(["block text-sm font-medium leading-6 text-gray-900", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  slot(:inner_block, required: true)

  def field_error(assigns) do
    ~H"""
    <p class="mt-2 text-sm text-red-600">
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
