defmodule Auth.Macro do
  defmacro __using__(options) do
    quote bind_quoted: [options: options] do
      Code.ensure_loaded!(Template.Auth.Behaviour)
      |> IO.puts
    end
  end
end
