defmodule Faulty.TCP.Utils do
  def opts() do
    [:binary, packet: 0, reuseaddr: true, active: true]
  end
end
