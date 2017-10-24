use Mix.Config

config :edges, Edges.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "edges_test",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
