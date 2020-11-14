defmodule Faulty.Utils do
  def get_network_config(app_name) when is_atom(app_name) do
    port = Application.get_env(app_name, :port, 50000)
    {port}
  end
end
