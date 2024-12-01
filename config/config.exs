# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :trudy_food_tracker,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :trudy_food_tracker, TrudyFoodTrackerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TrudyFoodTrackerWeb.ErrorHTML, json: TrudyFoodTrackerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TrudyFoodTracker.PubSub,
  live_view: [signing_salt: "6w26r0EP"]

  config :tailwind,
  version: "3.4.6",
  trudy_food_tracker: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configure esbuild
config :esbuild,
  version: "0.17.11",
  trudy_food_tracker: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
