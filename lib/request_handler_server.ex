defmodule RequestHandlerServer do
  @doc """
    Server responsible for handling request and transforming them
    as the main websocket server should stay clean as much as possible.
  """
  use GenServer

  #### Server code

  @impl true
  def init(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_cast({:raw_message, message}, socket) do
    message = MessageHandler.decode_message(message)
    socket = %{socket | message: message}
    send(self(), message)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:event, event}, socket) do
    event = Event.validate(event)
    response_event = MessageHandler.encode_message(event)
    {response_code, _} = event

    send(socket.pid, {response_code, response_event})
    {:noreply, socket}
  end


  ### Client side code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def process_message(message) do
    GenServer.cast(RequestHandlerServer, {:raw_message, message})
  end

end
