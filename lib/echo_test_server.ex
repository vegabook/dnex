defmodule EchoTestServer do
  # Will use module docs to document how things work
  @moduledoc """
    When connection is upgraded to websocket, it does not have any state, so it is basically on us to determine how
    that socket struct will look like.
    Some basic stuff from nostr nip 01 and for the rest is our decision in implementation
  """
  @behaviour WebSock

  @impl true
  def init(opts) do
    IO.puts("INIT")
    # When each new request comes in to app, new PID is started for that connection
    # We need to somehow store those PIDS (which should be connected clients) and push to them, when
    # each event comes in
    pid = self()
    IO.inspect(pid: pid)
    send(pid, {:message, "to handle_info"})
    IO.inspect(opts: opts)
    {:ok, opts}
  end

  @impl true
  def handle_in({event_or_string_message, _opts} = _message, websock_state) do
    {:push, {:text, String.upcase(event_or_string_message)}, websock_state}
  end

  # @impl true
  # def handle_control() do
  # end

  @doc """
  Handle info for handling internal elixir process messages
  usually emitted by GenServer, or basically any other elixir process
  """
  @impl true
  def handle_info({:message, msg}, state) do
    IO.puts("Handle info callback")
    IO.inspect(msg)
    {:ok, state}
  end

  @impl true
  def terminate(reason, state) do
    {:stop, reason, state}
  end
end
