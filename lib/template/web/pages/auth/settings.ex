defmodule Template.Web.Pages.Auth.Settings do
  @moduledoc false
  use Template.Web, :controller

  @flow_params ~w()

  def index(conn, params), do: render_or_request_new_flow(conn, params)

  defp render_or_request_new_flow(conn, %{"flow" => flow_id} = params), do: render_flow_if_valid(conn, flow_id, params)
  defp render_or_request_new_flow(conn, params), do: request_new_flow(conn, params)

  defp render_flow_if_valid(conn, flow_id, params) do
    case Kratos.Frontend.get_settings_flow(flow_id, cookie_header(conn)) do
      {:ok, %Kratos.Models.SettingsFlow{} = flow} ->
        render(conn, :index, flow: IO.inspect(flow))

      _ ->
        request_new_flow(conn, params)
    end
  end

  defp request_new_flow(conn, params) do
    query =
      @flow_params
      |> Enum.map(fn param -> {param, Map.get(params, param)} end)
      |> Enum.filter(fn {_, v} -> not is_nil(v) end)
      |> URI.encode_query()

    redirect(conn, external: Kratos.URI.getURIForFlow("settings", query))
  end
end

defmodule Template.Web.Pages.Auth.SettingsHTML do
  use Template.Web, :component

  import Template.Web.Components.Kratos.FlowForm
  import Template.Web.Components.Kratos.UINodes

  alias Template.Web.Components.Kratos.Helpers

  embed_templates("settings/*")
end
