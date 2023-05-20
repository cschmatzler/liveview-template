defmodule Template.Web.Pages.Auth.Login do
  @moduledoc false
  use Template.Web, :controller

  @flow_params [:aal, :refresh, :return_to]

  def index(conn, params), do: render_or_request_new_flow(conn, params)

  defp render_or_request_new_flow(conn, %{"flow" => flow} = params), do: render_flow_if_valid(conn, flow, params)
  defp render_or_request_new_flow(conn, params), do: request_new_flow(conn, params)

  defp render_flow_if_valid(conn, flow, params) do
    cookie_header = conn |> get_req_header("cookie") |> List.first()
    flow = flow |> Kratos.Frontend.get_login_flow(cookie_header) |> IO.inspect()

    case flow do
      {:ok, %Kratos.Models.GenericErrorResponse{error: %Kratos.Models.GenericError{code: 404}}} ->
        request_new_flow(conn, params)

      {:ok, %Kratos.Models.GenericErrorResponse{error: %Kratos.Models.GenericError{code: 410}}} ->
        request_new_flow(conn, params)

      {:ok, %Kratos.Models.LoginFlow{} = flow} ->
        render(conn, :index, flow: flow)
    end
  end

  defp request_new_flow(conn, params) do
    query =
      @flow_params
      |> Enum.map(fn param -> {param, Map.get(params, Atom.to_string(param))} end)
      |> Enum.filter(fn {_, v} -> not is_nil(v) end)
      |> URI.encode_query()

    redirect(conn,
      external: "http://liveview-template.test:8500/self-service/login/browser?#{query}"
    )
  end
end

defmodule Template.Web.Pages.Auth.LoginHTML do
  use Template.Web, :component

  embed_templates("login/*")
end
