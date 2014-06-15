defmodule CbstatsImporter.TimestampQuery do
  import Ecto.Query

  def timestamp_exists?(datetime) do
    query = from t in CbstatsImporter.Timestamp,
      where: t.taken_at == ^datetime,
      select: count(t.id)

    results = CbstatsImporter.Repo.all(query)
    List.first(results) > 0
  end
end
