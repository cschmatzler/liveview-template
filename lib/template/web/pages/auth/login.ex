defmodule Template.Web.Pages.Auth.Login do
  use Template.Web, :controller

  @flow_params [:aal, :refresh, :return_to]

  def index(conn, params) do
    cookie = get_session(conn, :cookie)
    query =
      Enum.map(@flow_params, fn param -> {param, Map.get(params, Atom.to_string(param))} end)
      |> Enum.filter(fn {_, v} -> not is_nil(v) end)
      |> URI.encode_query()

    case Map.get(params, "flow", "") do
      "" ->
        redirect(conn, external: "http://liveview-template.test:8500/kratos/self-service/login/browser?#{query}")

      id ->
        render(conn, :index)
    end
  end

  defp get_login_flow(flow_id, cookie) do
    IO.inspect(cookie)
    IO.inspect(Ory.Connection.new())
    flow = Ory.Api.Frontend.get_login_flow(Ory.Connection.new(), flow_id, cookie: cookie)
    IO.inspect(flow)
  end
end

defmodule Template.Web.Pages.Auth.LoginHTML do
  use Template.Web, :component

  embed_templates("login/*")
end
