defmodule CbstatsImporter.ImportProcess do
  def import_path(path) do
    {reading_datetime, results} = CbstatsImporter.ReadingParser.parse_json_file(path)
    existing_reading_station_ids = CbstatsImporter.ReadingQuery.timestamp_station_ids(reading_datetime)

    meta = {reading_datetime, existing_reading_station_ids, []}
    CbstatsImporter.ReadingImporter.import_results(results, meta)

    {:ok, 1}
  end
end
