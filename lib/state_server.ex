defmodule StateServer do
  use GenServer

  # Client

  # def start_link(opts) do
  #   GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  # end

  # Server

  @impl true
  def init(state) do
    init_state = %{msg: "Hello World"}
    {:ok, init_state}
  end
end
