defmodule Dnex.MixProject do
  use Mix.Project

  def project do
    [
      app: :dnex,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dnex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.5"},
      {:websock_adapter, "~> 0.5.7"},
      {:phoenix_pubsub, "~> 2.1"}
    ]
  end
end
