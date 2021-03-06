defmodule Faulty.TCP.Server do
  use GenServer, restart: :transient
  require Logger

  @prefix "TCP Server"

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [])
  end

  @impl true
  def init(_opts) do
    Logger.info("#{prefix()} started")
    {:ok, nil}
  end

  @impl true
  def handle_info({:tcp, _socket, packet}, state) do
    Logger.info("#{prefix()} received packet: #{packet}")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    Logger.info("#{prefix()} socket closed")
    {:stop, {:shutdown, :tcp_closed}, state}
  end

  @impl true
  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.info("#{prefix()} connection closed because: #{reason}")
    {:shutdown, {:shutdown, :tcp_error}, state}
  end

  @impl true
  def terminate({:shutdown, reason}, _state) do
    Logger.info("#{prefix()} stopping because: #{reason}")
  end

  defp prefix() do
    pid = inspect(self())
    "#{@prefix} with PID #{pid}"
  end
end
