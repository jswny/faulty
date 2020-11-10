defmodule Faulty.Supervisor do
  use DynamicSupervisor
  require Logger

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_child(:tcp_server) do
    child_spec = Faulty.TCPServer
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_opts) do
    pid = inspect(self())
    Logger.info("Supervisor started with PID #{pid}.")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
