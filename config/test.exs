use Mix.Config

config :cbstats_importer, CbstatsImporter.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "cbstats_importer_test",
  hostname: "localhost",
  username: "cbstats"
