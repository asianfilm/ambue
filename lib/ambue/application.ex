defmodule Ambue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ambue.Repo,
      AmbueWeb.Telemetry,
      {Phoenix.PubSub, name: Ambue.PubSub},
      AmbueWeb.Endpoint,
      Services.SessionCache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ambue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AmbueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
