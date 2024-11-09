defmodule MessageHandler do

  def decode_message(message) do
    {:ok, message} = Jason.decode(message)
    handle_message(message)
  end

  defp handle_message(["EVENT", event]), do: {:event, event}
  defp handle_message(["REQ", sub_id, filters]), do: {:req, sub_id, filters}

  def encode_message({:success_event, event}) do
    ["OK", event.id, true, "event received"] |> Jason.encode!()
  end
  def encode_message({:broadcast_event, event}) do
    event = Jason.encode!(event)
    IO.inspect(event)
    broadcast_event = ["EVENT", event] |> Jason.encode!()
    IO.inspect(broadcast_event)
  end
end
