defmodule Faulty.Supervisor do
  use DynamicSupervisor
  require Logger

  @prefix "Supervisor"

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(child_spec) do
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_opts) do
    pid = inspect(self())
    Logger.info("#{@prefix} started with PID #{pid}.")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
