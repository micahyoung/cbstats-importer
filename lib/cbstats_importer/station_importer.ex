defmodule CbstatsImporter.StationImporter do
  def import_stations(stations_dict, existing_station_ids) do
    Enum.each stations_dict, fn({id, attributes}) ->
      if !Enum.member?(existing_station_ids, id) do
        station = %CbstatsImporter.Station{
          id: id,
          created_at: CbstatsImporter.Util.now_datetime,
          updated_at: CbstatsImporter.Util.now_datetime
        }

        CbstatsImporter.Repo.insert(station)
      end
    end
  end
end
