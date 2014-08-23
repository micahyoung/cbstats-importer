defmodule CbstatsImporter.ImportProcess do
  def import_reading_json(json_content) do
    {reading_datetime, results} = CbstatsImporter.ReadingParser.parse_json(json_content)
    CbstatsImporter.TimestampImporter.import_timestamp(reading_datetime)

    existing_reading_station_ids = CbstatsImporter.ReadingQuery.timestamp_station_ids(reading_datetime)
    CbstatsImporter.ReadingImporter.import_results(results, reading_datetime, existing_reading_station_ids, [])

    {:ok, 1}
  end
end
