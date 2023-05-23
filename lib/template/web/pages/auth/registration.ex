defmodule Template.Web.Pages.Auth.Registration do
  use Template.Web, :controller

  @flow_params ~w(flow return_to after_verification_return_to)

  def index(conn, params), do: render_or_request_new_flow(conn, params)

  defp render_or_request_new_flow(conn, %{"flow" => flow_id} = params), do: render_flow_if_valid(conn, flow_id, params)
  defp render_or_request_new_flow(conn, params), do: request_new_flow(conn, params)

  defp render_flow_if_valid(conn, flow_id, params) do
    case Kratos.Frontend.get_registration_flow(flow_id, cookie_header(conn)) do
      {:ok, %Kratos.Models.RegistrationFlow{} = flow} ->
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

    redirect(conn, external: Kratos.URI.getURIForFlow("registration", query))
  end
end

defmodule Template.Web.Pages.Auth.RegistrationHTML do
  use Template.Web, :component

  embed_templates("registration/*")
end
