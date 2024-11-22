defmodule Websocket do
  @moduledoc """
  WebSocket Struct for tracking the websocket state.
  """
  defstruct [:connection_id, :user_agent, :remote_ip, :pid, :subscription_id]

  def init_state(conn, pid) do
    %__MODULE__{
      connection_id: get_connection_id(conn),
      user_agent: get_user_agent(conn),
      remote_ip: get_client_ip(conn),
      pid: pid
    }
  end

  defp get_connection_id(conn) do
    [id] = Plug.Conn.get_req_header(conn, "sec-websocket-key")

    id
    |> Base.decode64!()
    |> Base.encode16(case: :lower)
  end

  defp get_client_ip(conn) do
    conn.remote_ip
  end

  defp get_user_agent(conn) do
    Plug.Conn.get_req_header(conn, "user-agent")
  end

  def add_subscription_id(socket, subscription_id) do
    %{socket | subscription_id: subscription_id}
  end
end
