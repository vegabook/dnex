defmodule Request do
  @subscription_id_length 64

  def valid?({sub_id, filters}) do
    is_list(filters) and subscription_id_valid?(sub_id)
  end

  defp subscription_id_valid?(subscription_id)
       when is_binary(subscription_id) do
    String.length(subscription_id) <= @subscription_id_length
  end

  defp subscription_id_valid?(subscription_id)
       when not is_binary(subscription_id),
       do: false
end
