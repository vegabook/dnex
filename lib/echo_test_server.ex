defmodule TestServer do
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
  def handle_in({message, _opts}, socket) do
    {:ok, pid} = RequestHandlerServer.start_link(socket)
    socket = %{socket | request_handler_pid: pid}
    RequestHandlerServer.process_message(message)
    {:ok, socket}
  end


  @impl true
  def handle_info({:event_valid, response}, socket) do
    dbg(socket)
    # BROADCAST EVENTS
    {:push, {:text, response}, socket}
  end

  @impl true
  def handle_info({:event_invalid, response}, socket) do
    {:push, {:text, response}, socket}
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


  # Closing connection
  @impl true
  def handle_info({:close_connection}, socket) do
    {:stop, :normal, socket}
  end
end
