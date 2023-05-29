defmodule Template.Web.Pages.Auth.Recovery do
  @moduledoc false
  use Template.Web, :controller

  @flow_params ~w(flow return_to)

  def index(conn, params), do: render_or_request_new_flow(conn, params)

  defp render_or_request_new_flow(conn, %{"flow" => flow_id} = params),
    do: render_flow_if_valid(conn, flow_id, params)

  defp render_or_request_new_flow(conn, params), do: request_new_flow(conn, params)

  defp render_flow_if_valid(conn, flow_id, params) do
    case Kratos.Frontend.get_recovery_flow(flow_id, cookie_header(conn)) do
      {:ok, %Kratos.Models.RecoveryFlow{} = flow} ->
        render(conn, :index, flow: flow)

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

    redirect(conn, external: Kratos.URI.getURIForFlow("recovery", query))
  end
end

defmodule Template.Web.Pages.Auth.RecoveryHTML do
  use Template.Web, :component

  import Template.Web.Components.Kratos.Code
  import Template.Web.Components.Kratos.FlowForm

  embed_templates("recovery/*")
end
