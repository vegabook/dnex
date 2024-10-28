defmodule StateStruct do
  @moduledoc """
  WebSocket Struct for tracking the websocket state.
  """
  defstruct [:connection_id, :secure_websocket_key, :user_agent, :remote_ip]
end
