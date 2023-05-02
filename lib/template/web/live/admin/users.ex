defmodule Template.Web.Live.Admin.Users do
  use Template.Web, :live_view

  alias Template.Web.Components.Sidebar

  def render(assigns) do
    ~H"""
    <Sidebar.render />
    """
  end
end
