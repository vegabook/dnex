defmodule TestEndpoint do
  use Plug.Builder

  def init(opts) do
    IO.inspect(opts)
  end

  def call(conn, opts \\ []) do
    # Inspect the headers and path before upgrading to websocket
    # Track if IP is alredy connected, if it is we won't  allow more connections from same, as it might be a ddos attack
    socket = StateStruct.init_state(conn, self())
    WebSockAdapter.upgrade(conn, EchoTestServer, socket, timeout: :infinity)
    |> halt()
  end
end
