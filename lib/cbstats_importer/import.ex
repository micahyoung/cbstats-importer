defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", args

    json_paths = Path.wildcard("data/json/*.json")
    path_count = Enum.count(json_paths)

    rate_counter = RateCount.init(path_count)
    Enum.reduce json_paths, rate_counter, fn(path, counter) ->
      import_json_path(path)
      RateCount.update(counter)
    end
  end

  defp import_json_path(json_path) do
    {reading_datetime, results} = ReadingParser.parse_json_file(json_path)
    existing_reading_station_ids = ReadingQuery.timestamp_station_ids(reading_datetime)

    meta = {reading_datetime, existing_reading_station_ids}
    ReadingImporter.import_results(results, meta)
  end
end
