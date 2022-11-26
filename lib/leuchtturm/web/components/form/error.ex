defmodule Leuchtturm.Web.Components.Form.Error do
  use Leuchtturm.Web, :html

  import Phoenix.HTML.Form

  def error(assigns) do
    ~H"""
    <%= if error = Keyword.get(@form.errors, @field) do %>
      <span class="" phx-feedback-for={input_name(@form, @field)}>
        <%= elem(error, 0) %>
      </span>
    <% end %>
    """
  end
end
