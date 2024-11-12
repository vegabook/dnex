defmodule TestEndpoint do
  use Plug.Builder

  def init(opts) do
    IO.inspect(opts)
  end

  def call(conn, opts \\ []) do
    IO.inspect(conn)

    if conn.request_path == "/" do
      req_websocket(conn)
    else
      events_websocket(conn)
    end

    # Inspect the headers and path before upgrading to websocket
    # Track if IP is alredy connected, if it is we won't  allow more connections from same, as it might be a ddos attack
  end

  defp events_websocket(conn) do
    socket = StateStruct.init_state(conn, self())

    WebSockAdapter.upgrade(conn, EchoTestServer, socket, timeout: :infinity)
    |> halt()
  end

  defp req_websocket(conn) do
    WebSockAdapter.upgrade(conn, ReqTestServer, %{}, timeout: :infinity)
  end
end
