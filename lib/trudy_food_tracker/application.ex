defmodule TrudyFoodTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TrudyFoodTrackerWeb.Telemetry,
      {Phoenix.PubSub, name: TrudyFoodTracker.PubSub},
      TrudyFoodTrackerWeb.Endpoint,
      TrudyFoodTracker.FoodLog  # Add this line
    ]

    opts = [strategy: :one_for_one, name: TrudyFoodTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrudyFoodTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
