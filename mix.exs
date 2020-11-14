defmodule Faulty.MixProject do
  use Mix.Project

  def project do
    [
      app: :faulty,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Faulty.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp dialyzer() do
    plt_core_path = "_build/#{Mix.env()}/plt"

    [
      plt_core_path: plt_core_path,
      plt_file: {:no_warn, "#{plt_core_path}/dialyzer.plt"}
    ]
  end
end
