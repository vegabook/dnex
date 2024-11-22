defmodule WebsocketTest do
  @behaviour WebSock
  alias Phoenix.PubSub
  @impl true
  def init(state) do
    {:ok, %{pid: self()}}
  end

  @impl true
  def handle_in({msg, opts}, socket) do
    if msg == "hello" do
      message = msg <> " world"
      IO.inspect(event_pid: socket.pid)
      send(socket.pid, {:event, message})
    else
      IO.inspect(req_pid: socket.pid)
      send(socket.pid, {:req, "req"})
    end

    {:ok, socket}
  end

  @impl true
  def handle_info({:req, _msg}, state) do
    PubSub.subscribe(:dnex_pubsub, "events")
    IO.puts("subscribe")
    {:ok, state}
  end

  @impl true
  def handle_info({:event, event}, state) do
    PubSub.broadcast(:dnex_pubsub, "events", {:broadcast, event})
    IO.puts("broadcast")
    {:ok, state}
  end

  # PubSub needs callback to push to clients
  @impl true
  def handle_info({:broadcast, event}, state) do
    {:push, {:text, event}, state}
  end
end
