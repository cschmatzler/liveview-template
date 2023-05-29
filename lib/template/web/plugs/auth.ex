defmodule Template.Web.Plugs.Auth do
  # FIXME: documentation
  @moduledoc false

  import Plug.Conn

  require Logger

  def verify_session(conn, _opts) do
    cookie_header = cookie_header(conn)

    case Kratos.Frontend.get_session(cookie_header) do
      {:ok, %Kratos.Models.Session{} = session} ->
        conn
        |> put_session(:identity, session.identity)
        |> put_session(:cookie_header, cookie_header)
        |> put_session(:live_socket_id, "session:#{session.id}")

      {:ok, %Kratos.Models.GenericErrorResponse{} = error} ->
        Logger.error("Received error response from Kratos")

        conn

      {:error, error} ->
        Logger.error("Error while fetching session: #{error}")

        conn
    end
  end

  def cookie_header(conn) do
    conn
    |> get_req_header("cookie")
    |> List.first()
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&String.starts_with?(&1, "ory"))
    |> Enum.join(";") || ""
  end
end
