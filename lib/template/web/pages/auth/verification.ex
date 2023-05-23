defmodule Template.Web.Pages.Auth.Verification do
  use Template.Web, :controller

  @flow_params ~w(flow return_to message)

  def index(conn, params), do: render_or_request_new_flow(conn, params)

  defp render_or_request_new_flow(conn, %{"flow" => flow_id} = params), do: render_flow_if_valid(conn, flow_id, params)
  defp render_or_request_new_flow(conn, params), do: request_new_flow(conn, params)

  defp render_flow_if_valid(conn, flow_id, params) do
    case Kratos.Frontend.get_verification_flow(flow_id, cookie_header(conn)) do
      {:ok, %Kratos.Models.VerificationFlow{} = flow} ->
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

    redirect(conn, external: Kratos.URI.getURIForFlow("verification", query))
  end
end

defmodule Template.Web.Pages.Auth.VerificationHTML do
  use Template.Web, :component

  embed_templates("verification/*")
end
