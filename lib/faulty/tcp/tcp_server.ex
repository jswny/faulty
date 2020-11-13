defmodule Faulty.TCP.Server do
  use GenServer
  require Logger

  @prefix "TCP Server"

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :transient
    }
  end

  def start_link(_opts) do
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
    {:stop, :tcp_closed, state}
  end

  @impl true
  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.info("#{prefix()} connection closed because: #{reason}")
    {:stop, :tcp_error, state}
  end

  defp prefix() do
    pid = inspect(self())

    "#{@prefix} with PID #{pid}"
  end
end
