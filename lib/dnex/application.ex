defmodule Dnex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    webserver = {Bandit, scheme: :http, plug: TestEndpoint, port: 4000}
    pubsub_server = {Phoenix.PubSub, name: :dnex_pubsub}

    children = [
      webserver,
      pubsub_server
      # Starts a worker by calling: Dnex.Worker.start_link(arg)
      # {Dnex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dnex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
