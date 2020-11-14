defmodule Faulty.TCP.ServerSupervisor do
  use DynamicSupervisor
  require Logger
  alias Faulty.TCP

  @prefix "TCP Server Supervisor"

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child_server() do
    child_spec = TCP.Server
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_opts) do
    pid = inspect(self())
    Logger.info("#{@prefix} started with PID #{pid}.")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
