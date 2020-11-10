defmodule Faulty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Faulty.TCPServer
    ]

    opts = [strategy: :one_for_one, name: Faulty.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
