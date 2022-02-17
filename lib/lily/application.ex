defmodule Lily.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Lily.Repo,
      # Start the Telemetry supervisor
      LilyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lily.PubSub},
      # Start the Endpoint (http/https)
      LilyWeb.Endpoint
      # Start a worker by calling: Lily.Worker.start_link(arg)
      # {Lily.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lily.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LilyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
