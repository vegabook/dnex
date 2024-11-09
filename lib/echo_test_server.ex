defmodule EchoTestServer do
  # Will use module docs to document how things work
  @moduledoc """
    When connection is upgraded to websocket, it does not have any state, so it is basically on us to determine how
    that socket struct will look like.
    Some basic stuff from nostr nip 01 and for the rest is our decision in implementation
  """
  @behaviour WebSock

  @impl true
  def init(socket) do
    # When each new request comes in to app, new PID is started for that connection
    # We need to somehow store those PIDS (which should be connected clients) and push to them, when
    # each event comes in


    # We can do more transformations of socket here!
    {:ok, socket}
  end

  @impl true
  def handle_in({message, _opts} = _message, websock_state) do
    message = MessageHandler.decode_message(message)
    send(websock_state.pid, {:message, message})
    {:ok, websock_state}
  end

  @doc """
  Handle incoming events from websocket connection.
    """
  @impl true
  def handle_info({:message, {:event, event}}, socket) do
    event = Event.parse(event)
    send(socket.pid, {:success_event, event})
    {:ok, socket}
  end

  @impl true
  def handle_info({:message, {:req, _sub_id, _filters}}, state) do
    Phoenix.PubSub.subscribe(:dnex_pubsub, "events")
    IO.puts("Subscribed to events")
    {:ok, state}
  end


  @impl true
  def handle_info({:success_event, event}, socket) do
    event_response = MessageHandler.encode_message({:success_event, event})
    broadcast_event(event)
    {:push, {:text, event_response}, socket}
  end


  defp broadcast_event(event) do
    #event = MessageHandler.encode_message({:broadcast_event, event})
    Phoenix.PubSub.broadcast(:dnex_pubsub, "events", "hello to all req subs")
  end


  @impl true
  def terminate(reason, state) do
    {:stop, reason, state}
  end

end
