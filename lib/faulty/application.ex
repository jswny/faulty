defmodule Faulty.Application do
  @moduledoc false

  use Application
  require Logger
  alias Faulty.Utils

  @impl true
  def start(_type, _args) do
    Logger.info("Application started")
    opts = [strategy: :one_for_one, name: Faulty.Supervisor]
    {:ok, server_pid} = Faulty.Supervisor.start_link(opts)

    app_name = Application.get_application(__MODULE__)
    {address, port} = Utils.get_network_config(app_name)

    tcp_acceptor_spec =
      Supervisor.child_spec({Task, fn -> Faulty.TCP.Acceptor.accept(address, port) end},
        restart: :permanent
      )

    tcp_server_supervisor_spec = Faulty.TCP.ServerSupervisor

    # IO.inspect(acceptor_spec)

    {:ok, _pid} = Faulty.Supervisor.start_child(tcp_server_supervisor_spec)
    {:ok, _pid} = Faulty.Supervisor.start_child(tcp_acceptor_spec)

    {:ok, server_pid}
  end
end
