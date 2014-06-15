defmodule CbstatsImporter.ImportProcess do
  def import_path(path) do
    {reading_datetime, results} = CbstatsImporter.ReadingParser.parse_json_file(path)
    CbstatsImporter.TimestampImporter.import_timestamp(reading_datetime)

    existing_reading_station_ids = CbstatsImporter.ReadingQuery.timestamp_station_ids(reading_datetime)
    CbstatsImporter.ReadingImporter.import_results(results, reading_datetime, existing_reading_station_ids, [])

    {:ok, 1}
  end
end
