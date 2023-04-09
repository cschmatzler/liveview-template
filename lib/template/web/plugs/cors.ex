defmodule Template.Web.Plugs.CORS do
  use Corsica.Router,
      Application.compile_env(:template, Corsica)
end
