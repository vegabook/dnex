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

  def parse(event) do
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
end
