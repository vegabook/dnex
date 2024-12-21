defmodule MessageHandler do
  def decode_message(message) do
    {:ok, message} = Jason.decode(message)
    handle_message(message)
  end

  defp handle_message(["EVENT", event]), do: {:event, event}
  defp handle_message(["REQ", sub_id, filters]), do: {:req, sub_id, filters}

  # Per nip01 this JSON response is used to indicate the success of the
  # messages receieved.
  # The message sent to the client is
  # ["OK", <event_id>, <true|false>, <message>]
  # message should be in format prefix:message -> e.g. invalid: event crypto not valid.
  # "OK" messages are sent to response of the event received messages

  def encode_message(message)

  def encode_message({:success_event, event}) do
    ["OK", event.id, true, ""] |> Jason.encode!()
  end

  def encode_message({:bad_event, event}) do
    ["OK", event.id, false, "invalid: event crypto is not valid!"]
    |> Jason.encode!()
  end

  def encode_message({:error_request, sub_id}) do
    ["CLOSED", sub_id, "invalid: request invalid!"] |> Jason.encode!()
  end

  def encode_message({:event, event}, sub_id) do
    ["EVENT", sub_id, event]
    |> Jason.encode!()
  end
end
