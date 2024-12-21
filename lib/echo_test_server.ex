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
    {response, event} = Event.validate(event)
    send(socket.pid, {response, event})
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
  def handle_info({:success_req, _sub_id, _filters}, socket) do
    PubSub.subscribe(:dnex_pubsub, "events")
    {:ok, socket}
  end

  @impl true
  def handle_info({:error_req, sub_id}, socket) do
    error_request = MessageHandler.encode_message({:error_request, sub_id})
    send(socket.pid, {:close_connection})
    {:push, {:text, error_request}, socket}
  end

  @impl true
  def handle_info({:valid, event}, socket) do
    event_response = MessageHandler.encode_message({:success_event, event})
    PubSub.broadcast(:dnex_pubsub, "events", {:broadcast_event, event})
    {:push, {:text, event_response}, socket}
  end

  @impl true
  def handle_info({:invalid, event}, socket) do
    event_response = MessageHandler.encode_message({:bad_event, event})
    {:push, {:text, event_response}, socket}
  end

  ### Handler for pubsub broadcasting event
  @impl true
  def handle_info({:broadcast_event, event}, socket) do
    sub_id = ":1"
    event = MessageHandler.encode_message({:event, event}, sub_id)

    {:push, {:text, event}, socket}
  end

  # Closing connection
  @impl true
  def handle_info({:close_connection}, socket) do
    {:stop, :normal, socket}
  end
end
