defmodule Faulty.TCPServer do
  use GenServer
  require Logger
  alias Faulty.Util

  @prefix "TCP Server"
  @app_name :faulty

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link(_opts) do
    {address, port} = Util.get_network_config(@app_name)
    GenServer.start_link(__MODULE__, [address, port], [])
  end

  @impl true
  def init([address, port]) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active, true}, {:ip, address}])

    address_string = Util.address_tuple_to_string(address)

    Logger.info("#{@prefix} started on address #{address_string} and port #{port}")

    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:ok, %{address: address, port: port, socket: socket}}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    Logger.info("#{@prefix} received packet: #{packet}")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    Logger.info("#{@prefix} socket closed")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.info("#{@prefix} connection closed because: #{reason}")
    {:noreply, state}
  end
end
