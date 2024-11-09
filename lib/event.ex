defmodule Event do
  @moduledoc """
    Module to parse events from a client and validate the values
    such as signature and pubkey.
    """
##TODO: DERIVE JASON SO ENCODING FROM ALREADY PARSED EVENTS CAN BE BROADCASTED


 ### Questions:
# Make use of embed schema to validate the values of the event ?
# With embed schema we can leverage the ecto changeset functions and
# avoid parsing manually which can cause errors.

  defstruct [:kind, :created_at, :content, :id, :pubkey, :sig, :tags]


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
