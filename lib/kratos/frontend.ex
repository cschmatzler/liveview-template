defmodule Kratos.Frontend do
  @moduledoc false
  use Tesla

  require Logger

  def to_session(cookie) do
    Kratos.Client.new()
    |> Tesla.get("/sessions/whoami", headers: [{"cookie", cookie}])
    |> map_response([
      {200, Kratos.Models.Session},
      {401, Kratos.Models.GenericErrorResponse},
      {403, Kratos.Models.GenericErrorResponse},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_login_flow(id, cookie) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/login/flows", query: [id: id], headers: [{"cookie", cookie}])
    |> map_response([
      {200, Kratos.Models.LoginFlow},
      {401, Kratos.Models.GenericErrorResponse},
      {404, Kratos.Models.GenericErrorResponse},
      {410, Kratos.Models.GenericErrorResponse},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  defp map_response({:ok, %Tesla.Env{} = env}, mapping), do: resolve_mapping(env, mapping, nil)
  defp map_response({:error, _} = error, _mapping), do: error

  defp resolve_mapping(%Tesla.Env{status: status} = env, [{status_code, struct} | _], _) when status == status_code do
    decode(env, struct)
  end

  defp resolve_mapping(env, [{:default, struct} | tail], _), do: resolve_mapping(env, tail, struct)
  defp resolve_mapping(env, [_ | tail], struct), do: resolve_mapping(env, tail, struct)
  defp resolve_mapping(env, [], nil), do: {:error, env}
  defp resolve_mapping(env, [], struct), do: decode(env, struct)
  defp decode(%Tesla.Env{} = env, false), do: {:ok, env}
  defp decode(%Tesla.Env{body: body}, struct), do: Nestru.decode_from_map(body, struct)
end
