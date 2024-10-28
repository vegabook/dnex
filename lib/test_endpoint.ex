defmodule TestEndpoint do
  use Plug.Builder

  def init(opts) do
    IO.inspect(opts)
  end

  def call(conn, opts \\ []) do
    WebSockAdapter.upgrade(conn, EchoTestServer, %StateStruct{}, timeout: 120_000)
    |> halt()
  end
end
