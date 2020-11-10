defmodule Faulty.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Application started")
    opts = [strategy: :one_for_one, name: Faulty.Supervisor]
    {:ok, pid} = Faulty.Supervisor.start_link(opts)

    Faulty.Supervisor.start_child(:tcp_server)

    {:ok, pid}
  end
end
