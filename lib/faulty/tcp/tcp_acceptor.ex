defmodule Faulty.TCP.Acceptor do
  use Task, restart: :permanent
  require Logger
  alias Faulty.TCP

  @prefix "TCP Acceptor"

  def start_link(port) when is_integer(port) do
    Task.start_link(__MODULE__, :accept, [port])
  end

  def accept(port) when is_integer(port) do
    with {:ok, socket} <- listen(port) do
      pid = inspect(self())

      Logger.info("#{@prefix} started listening on port #{port} with PID #{pid}")

      loop_acceptor(socket)
    else
      {:error, reason} -> Logger.error("#{@prefix} could not listen because #{reason}")
    end
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    Logger.info("#{@prefix} accepted connection")

    {:ok, pid} = Faulty.TCP.ServerSupervisor.start_child_server()

    Logger.info("#{@prefix} handed connection off")

    :ok = :gen_tcp.controlling_process(client, pid)

    loop_acceptor(socket)
  end

  defp listen(port) when is_integer(port) do
    opts = TCP.Utils.opts()
    :gen_tcp.listen(port, opts)
  end
end
