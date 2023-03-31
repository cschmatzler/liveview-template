defmodule Template.Web.Layouts do
  @moduledoc false

  use Template.Web, :component

  embed_templates "layouts/*"
end
