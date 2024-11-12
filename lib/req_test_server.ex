defmodule ReqTestServer do
  alias Phoenix.PubSub
  @behaviour WebSock

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_in(msg, state) do
    IO.inspect(msg)
    PubSub.subscribe(:dnex_pubsub, "events")
    {:ok, state}
  end

  @impl true
  def handle_info({:request, msg}, state) do
    {:push, {:text, msg}, state}
  end

  @impl true
  def terminate(reason, state) do
    {:ok, reason, state}
  end
end
