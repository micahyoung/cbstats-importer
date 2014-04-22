defmodule CbstatsImporter.ImportProcess do
  def import_loop() do
    receive do
      {:import_paths, paths} ->
        {:ok, count} = import_json_path(paths)
        import_loop()
      reason -> IO.puts "Failed #{reason}"
    end
  end

  defp import_json_path(json_paths) do
    path_count = Enum.count(json_paths)
    counter = CbstatsImporter.RateCount.init(path_count)

    Enum.reduce json_paths, counter, fn(json_path, counter) ->
      {reading_datetime, results} = CbstatsImporter.ReadingParser.parse_json_file(json_path)
      existing_reading_station_ids = CbstatsImporter.ReadingQuery.timestamp_station_ids(reading_datetime)

      meta = {reading_datetime, existing_reading_station_ids, []}
      CbstatsImporter.ReadingImporter.import_results(results, meta)

      CbstatsImporter.RateCount.update(counter)
    end

    {:ok, 1}
  end
end
