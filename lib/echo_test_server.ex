defmodule EchoTestServer do
  alias Phoenix.PubSub
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
  def handle_in({message, _opts} = _message, socket) do
    message = MessageHandler.decode_message(message)
    send(socket.pid, {:message, message})
    {:ok, socket}
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
  def handle_info({:message, {:req, sub_id, filters}}, socket) do
    if Request.valid?({sub_id, filters}) do
      send(socket.pid, {:success_req, sub_id, filters})
    else
      send(socket.pid, {:error_req, sub_id})
    end

    {:ok, socket}
  end

  @impl true
  def handle_info({:success_req, sub_id, filters}, socket) do
    PubSub.subscribe(:dnex_pubsub, "events")
    {:ok, socket}
  end

  @impl true
  def handle_info({:error_req, sub_id}, socket) do
    error_request = MessageHandler.encode_message({:error_request, sub_id, "invalid"})
    IO.inspect(error_request: error_request)
    {:push, {:text, error_request}, socket}
  end

  @impl true
  def handle_info({:success_event, event}, socket) do
    IO.puts("Success event")
    event_response = MessageHandler.encode_message({:success_event, event})
    PubSub.broadcast(:dnex_pubsub, "events", {:broadcast_event, event})
    {:push, {:text, event_response}, socket}
  end

  ### Handler for pubsub broadcasting event
  @impl true
  def handle_info({:broadcast_event, event}, socket) do
    IO.puts("Broadcast event")
    sub_id = ":1"
    event = MessageHandler.encode_message({:event, event}, sub_id)

    {:push, {:text, event}, socket}
  end

  @impl true
  def terminate(reason, socket) do
    {:stop, reason, socket}
  end
end
