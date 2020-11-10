defmodule Faulty.TCPServer do
  use GenServer
  require Logger
  alias Faulty.Utils
  alias Faulty.TCPUtils

  @prefix "TCP Server"
  @app_name :faulty

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link(_opts) do
    {address, port} = Utils.get_network_config(@app_name)
    GenServer.start_link(__MODULE__, [address, port], [])
  end

  @impl true
  def init([address, port]) do
    address_string = Utils.address_tuple_to_string(address)
    pid = inspect(self())

    Logger.info(
      "#{@prefix} started with address #{address_string} and port #{port} with PID #{pid}"
    )

    socket = listen(address, port)
    {:ok, %{address: address, port: port, socket: socket}}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    Logger.info("#{@prefix} received packet: #{packet}")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, _state) do
    Logger.info("#{@prefix} socket closed")
    exit(:tcp_closed)
  end

  @impl true
  def handle_info({:tcp_error, _socket, reason}, _state) do
    Logger.info("#{@prefix} connection closed because: #{reason}")
    exit(:tcp_error)
  end

  defp listen({:ok, listen_socket}, port) do
    Logger.info("#{@prefix} started listening on port #{port}.")
    accept_connection(listen_socket, port)
  end

  defp listen({:error, reason}, port) do
    Logger.error("#{@prefix} could not listen on port #{port}, reason: #{reason}")
    exit(:normal)
  end

  defp listen(address, port) do
    :gen_tcp.listen(port, TCPUtils.tcp_opts(address))
    |> listen(port)
  end

  # Accepts an incoming connection.
  defp accept_connection({:ok, socket}, port) do
    Logger.info("#{@prefix} accepted connection on #{port}.")
    socket
  end

  defp accept_connection(listen_socket, port) do
    :gen_tcp.accept(listen_socket) |> accept_connection(port)
  end
end
