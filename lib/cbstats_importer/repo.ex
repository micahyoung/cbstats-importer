defmodule CbstatsImporter.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  @doc "Adapter configuration"
  def conf(env), do: parse_url url(env)

  @doc "The priv directory to load migrations and metadata."
  def priv do
    app_dir(:cbstats_importer, "priv/repo")
  end

  defp url(:dev) do
    "ecto://cbstats@localhost/cbstats_development"
  end

  defp url(:test) do
    "ecto://cbstats@localhost/cbstats_importer_test"
  end

  defp url(:prod) do
    "ecto://cbstats@localhost/cbstats_production"
  end
end
