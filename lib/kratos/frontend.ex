defmodule Kratos.Frontend do
  @moduledoc false
  use Tesla

  require Logger

  def get_session(cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/sessions/whoami", headers: [{"cookie", cookie_header}])
    |> map_response([
      {200, Kratos.Models.Session},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_login_flow(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/login/flows",
      query: [id: id],
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.LoginFlow},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_registration_flow(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/registration/flows",
      query: [id: id],
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.RegistrationFlow},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_verification_flow(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/verification/flows",
      query: [id: id],
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.VerificationFlow},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_recovery_flow(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/recovery/flows",
      query: [id: id],
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.RecoveryFlow},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_settings_flow(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/settings/flows",
      query: [id: id],
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.SettingsFlow},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def get_flow_error(id, cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/errors", query: [id: id], headers: [{"cookie", cookie_header}])
    |> map_response([
      {200, Kratos.Models.FlowError},
      {:default, Kratos.Models.GenericErrorResponse}
    ])
  end

  def create_logout_flow(cookie_header) do
    Kratos.Client.new()
    |> Tesla.get("/self-service/logout/browser",
      headers: [{"cookie", cookie_header}]
    )
    |> map_response([
      {200, Kratos.Models.LogoutFlow},
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
