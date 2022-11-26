defmodule Leuchtturm.Web.Components.Form do
  alias Leuchtturm.Web.Components.Form

  defdelegate error(assigns), to: Form.Error
end
