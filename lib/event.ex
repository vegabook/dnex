defmodule Event do
  @derive Jason.Encoder
  @moduledoc """
  Module to parse events from a client and validate the values
  such as signature and pubkey.
  """

  defstruct [:kind, :created_at, :content, :id, :pubkey, :sig, :tags]

  ### Questions:
  # Make use of embed schema to validate the values of the event ?
  # With embed schema we can leverage the ecto changeset functions and
  # avoid parsing manually which can cause errors.

  def validate(raw_event) do
    event = parse(raw_event)

    case validate_signature(event) do
      {:ok, :valid_event} -> {:valid, event}
      {:error, :invalid_event} -> {:invalid, event}
    end
  end

  defp parse(event) do
    %__MODULE__{
      id: event["id"],
      created_at: event["created_at"],
      content: event["content"],
      kind: event["kind"],
      pubkey: event["pubkey"],
      sig: event["sig"],
      tags: event["tags"]
    }
  end

  defp validate_signature(%Event{id: id, pubkey: pubkey, sig: signature}) do
    {:ok, msg_id} = Base.decode16(id, case: :lower)
    {:ok, pubkey} = Base.decode16(pubkey, case: :lower)
    {:ok, signature} = Base.decode16(signature, case: :lower)

    case K256.Schnorr.verify_message_digest(msg_id, signature, pubkey) do
      :ok -> {:ok, :valid_event}
      {:error, _} -> {:error, :invalid_event}
    end
  end
end
