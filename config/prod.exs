use Mix.Config

config :cbstats_importer, CbstatsImporter.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "cbstats_production",
  hostname: "localhost",
  username: "cbstats"

