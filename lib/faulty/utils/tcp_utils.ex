defmodule Faulty.TCPUtils do
  def tcp_opts(address) do
    [:binary, packet: 0, reuseaddr: true, active: true, ip: address]
  end
end
