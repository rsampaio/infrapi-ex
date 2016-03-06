# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configure guardian
config :guardian, Guardian,
  issuer: "infrapi",
  ttl: { 60, :minutes},
  secret_key: "1e4d195a7c0ee1306062b353eefc28fb8ead50aac73520b99f117dc59d6c1b8e",
  serializer: Infrapi.GuardianSerializer


# Configures the endpoint
config :infrapi, Infrapi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Wj1OQY/KexN5qpZ73AS23bQ1sEIhjajfxuOhrEqaBdz1W6lfMMQRSyA0w3K8sgEE",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Infrapi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
