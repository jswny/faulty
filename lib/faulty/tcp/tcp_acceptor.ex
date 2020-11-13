defmodule Faulty.TCP.Acceptor do
  require Logger
  alias Faulty.TCP
  alias Faulty.Utils

  @prefix "TCP Acceptor"

  def accept(address, port) do
    with {:ok, socket} <- listen(address, port) do
      address_string = Utils.address_tuple_to_string(address)
      pid = inspect(self())

      Logger.info(
        "#{@prefix} started listening on address #{address_string} and port #{port} with PID #{
          pid
        }"
      )

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

  defp listen(address, port) do
    opts = TCP.Utils.opts(address)
    :gen_tcp.listen(port, opts)
  end
end
