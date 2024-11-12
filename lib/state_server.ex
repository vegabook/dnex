defmodule StateServer do
  use GenServer

  # Client

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, %{pids: []}, name: __MODULE__)
  end

  # Server

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:hello, msg}, from, state) do
  end
end
