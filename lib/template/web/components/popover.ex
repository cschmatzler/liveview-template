defmodule Template.Web.Components.Popover do
  use Template.Web, :component

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :class, :string
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  slot :inner_block, required: true
  slot :title
  slot :subtitle
  slot :confirm
  slot :cancel

  def popover(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_popover(@id)}
      class={[
        "absolute right-0 z-10 p-6 mt-2 w-64 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none",
        @class
      ]}
    >
      <.focus_wrap
        id={"#{@id}-container"}
        phx-mounted={@show && show_popover(@id)}
        phx-window-keydown={hide_popover(@on_cancel, @id)}
        phx-key="escape"
        phx-click-away={hide_popover(@on_cancel, @id)}
        class="hidden relative rounded-2xl bg-white p-14 shadow-lg shadow-zinc-700/10 ring-1 ring-zinc-700/10 transition"
      >
        Hello hello
      </.focus_wrap>
    </div>
    """
  end

  def show_popover(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
  end

  def hide_popover(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.hide(to: "##{id}")
  end
end
