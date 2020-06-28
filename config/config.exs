# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :trivial,
  ecto_repos: [Trivial.Repo]

# Configures the endpoint
config :trivial, TrivialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HKXTDOPeijpbptnM99r6ViBfN9lr17/l67IgMk2Wu+IYal9ps0BNSf9Ad0z2f9yR",
  render_errors: [view: TrivialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Trivial.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: System.get_env("SECRET_SALT")]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
