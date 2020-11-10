defmodule Faulty.TCPUtils do
  def opts(address) do
    [:binary, packet: 0, reuseaddr: true, active: true, ip: address]
  end
end
