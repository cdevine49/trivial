use Mix.Config

# Configure your database
config :trivial, Trivial.Repo,
  username: "postgres",
  password: "postgres",
  database: "trivial_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trivial, TrivialWeb.Endpoint,
  http: [port: 4002],
  server: true

config :trivial, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby, otp_app: :trivial, driver: Wallaby.Chrome

config :pbkdf2_elixir, :rounds, 1
