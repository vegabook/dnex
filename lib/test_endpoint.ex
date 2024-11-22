defmodule TestEndpoint do
  use Plug.Builder

  def init(opts) do
    IO.inspect(opts)
  end

  def call(conn, opts \\ []) do
    websocket = Websocket.init_state(conn, self())
    # Inspect the headers and path before upgrading to websocket
    # Track if IP is alredy connected, if it is we won't  allow more connections from same, as it might be a ddos attack
    WebSockAdapter.upgrade(conn, EchoTestServer, websocket, timeout: :infinity)
    |> halt()
  end
end
