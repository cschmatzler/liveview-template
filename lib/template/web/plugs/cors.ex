defmodule Template.Web.Plugs.CORS do
  @moduledoc false

  use Corsica.Router,
      Application.compile_env(:template, Corsica)
end
