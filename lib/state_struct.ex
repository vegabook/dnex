defmodule StateStruct do
  @moduledoc """
  WebSocket Struct for tracking the websocket state.
  """
  defstruct [:connection_id, :user_agent, :remote_ip, :pid]


  def init_state(conn, pid) do
    %__MODULE__{
      connection_id: get_connection_id(conn),
      user_agent: get_user_agent(conn),
      remote_ip: get_client_ip(conn),
      pid: pid
    }
  end


  defp get_connection_id(conn) do
    [v] = Plug.Conn.get_req_header(conn, "sec-websocket-key")
    v
    |> Base.decode64!()
    |> Base.encode16(case: :lower)
  end


  defp get_client_ip(conn) do
    conn.remote_ip
  end


  defp get_user_agent(conn) do
    user_agent = Plug.Conn.get_req_header(conn, "user-agent")
    user_agent || nil
  end


end
