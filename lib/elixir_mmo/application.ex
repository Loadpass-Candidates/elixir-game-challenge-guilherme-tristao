defmodule ElixirMmo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @env Mix.env()

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixirMmoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirMmo.PubSub},
      # Start Finch
      {Finch, name: ElixirMmo.Finch},
      # Start the Endpoint (http/https)
      ElixirMmoWeb.Endpoint,
      # Start a worker by calling: ElixirMmo.Worker.start_link(arg)
      # {ElixirMmo.Worker, arg}
      {Registry, keys: :unique, name: ElixirMmo.HeroRegistry},
    ]

    children =
      if @env != :test do
        children ++ [ElixirMmo.GameServer]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMmo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirMmoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
