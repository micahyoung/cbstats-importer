defmodule CbstatsImporter.StationQuery do
  import Ecto.Query

  def station_ids do
    query = from s in CbstatsImporter.Station,
      select: s.id

    CbstatsImporter.Repo.all(query)
  end
end
