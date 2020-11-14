defmodule Faulty.Application do
  @moduledoc false

  use Application
  require Logger
  alias Faulty.Utils
  alias Faulty.TCP

  @impl true
  def start(_type, _args) do
    Logger.info("Application started")
    opts = [strategy: :one_for_one, name: Faulty.Supervisor]
    {:ok, server_pid} = Faulty.Supervisor.start_link(opts)

    app_name = Application.get_application(__MODULE__)
    {port} = Utils.get_network_config(app_name)

    tcp_acceptor_spec = {TCP.Acceptor, port}
    tcp_server_supervisor_spec = TCP.ServerSupervisor

    {:ok, _pid} = Faulty.Supervisor.start_child(tcp_server_supervisor_spec)
    {:ok, _pid} = Faulty.Supervisor.start_child(tcp_acceptor_spec)

    {:ok, server_pid}
  end
end
