defmodule Faulty.TCPServer do
  use GenServer
  require Logger

  @prefix "TCP Server"

  def start_link([ip, port]) do
    GenServer.start_link(__MODULE__, [ip, port], [])
  end

  @impl true
  def init([ip, port]) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active, true}, {:ip, ip}])

    Logger.info("#{@prefix} started")

    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:ok, %{ip: ip, port: port, socket: socket}}
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
