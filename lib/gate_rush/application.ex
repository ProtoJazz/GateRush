defmodule GateRush.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GateRushWeb.Telemetry,
      GateRush.Repo,
      {DNSCluster, query: Application.get_env(:gate_rush, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GateRush.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GateRush.Finch},
      # Start a worker by calling: GateRush.Worker.start_link(arg)
      # {GateRush.Worker, arg},
      # Start to serve requests, typically the last entry
      GateRushWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GateRush.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GateRushWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
