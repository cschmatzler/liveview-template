defmodule Template.Web.Plugs.Auth do
  # FIXME: documentation
  @moduledoc false

  import Plug.Conn, only: [  get_req_header: 2, put_session: 3 ]

  require Logger

  def verify_session(conn, _opts) do
    cookie_header = conn |> get_req_header("cookie") |> List.first() || ""

    case Kratos.Frontend.to_session(cookie_header) do
      {:ok, %Kratos.Models.Session{} = session} ->
        conn
        |> put_session(:session, session)
        # |> put_session(:live_socket_id, "session:#{Jason.encode!(session)}")

      {:ok, %Kratos.Models.GenericErrorResponse{} = error} ->
        IO.inspect(error)
        conn

      {:error, error} ->
        Logger.error("Error while fetching session: #{error}")

        conn
    end
  end
end
