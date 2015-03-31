use Mix.Config

config :cbstats_importer, CbstatsImporter.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "cbstats_development",
  hostname: "localhost",
  username: "cbstats"

