defmodule Template.Web.Plugs.Auth do
  # FIXME: documentation
  @moduledoc false
  import Plug.Conn, only: [delete_session: 2, get_session: 2, get_req_header: 2, put_session: 3]

  def verify_session(conn, _opts) do
    cookie = get_req_header(conn, "cookie") |> List.first() |> IO.inspect()

    conn =
      if get_session(conn, :cookie) do
        conn
        |> delete_session(:cookie)
        |> put_session(:cookie, cookie)
      else
        put_session(conn, :cookie, cookie)
      end

    case Ory.Api.Frontend.to_session(Ory.Connection.new(), cookie: cookie) do
      {:ok, %Ory.Model.Session{} = session} ->
        conn
        |> put_session(:session, session)
        |> put_session(:live_socket_id, "session:#{Jason.encode!(session)}")

      {:ok, %Ory.Model.ErrorGeneric{}} ->
        conn

      {:error, error} ->
        IO.inspect(error)
        conn
    end
  end
end
