defmodule Faulty.Util do
  def get_network_config(app_name) when is_atom(app_name) do
    address = Application.get_env(app_name, :address, {127, 0, 0, 1})
    port = Application.get_env(app_name, :port, 50000)
    {address, port}
  end

  def address_tuple_to_string(address) when is_tuple(address) do
    {a, b, c, d} = address
    "#{a}.#{b}.#{c}.#{d}"
  end
end
