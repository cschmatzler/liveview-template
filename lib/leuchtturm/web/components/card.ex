defmodule Leuchtturm.Web.Components.Card do
  use Leuchtturm.Web, :html

  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class="overflow-hidden bg-white shadow sm:rounded-lg">
      <div class="py-5 px-4 sm:p-6">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
