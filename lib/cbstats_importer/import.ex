defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", args

    json_paths = Path.wildcard("data/json/*.json")
    start_mon = HashDict.new [index: 0, last_index: 0, last_seconds: Util.now_seconds]

    Enum.reduce json_paths, start_mon, fn(path, rate_mon) ->
      elapsed_seconds = Util.now_seconds - rate_mon[:last_seconds]
      if elapsed_seconds > 5 do
        elapsed_records = rate_mon[:index] - rate_mon[:last_index]
        rate = Float.floor(elapsed_records / elapsed_seconds)
        IO.puts "#{rate} files/s"
        last_seconds = Util.now_seconds
        last_index = rate_mon[:index]
      else
        last_seconds = rate_mon[:last_seconds]
        last_index = rate_mon[:last_index]
      end

      index = import_json_path(path, rate_mon[:index])
      HashDict.new [index: index, last_index: last_index, last_seconds: last_seconds]
    end
  end

  defp import_json_path(json_path, index) do
    {:ok, json_content} = File.read(json_path)
    {:ok, json_hash} = JSON.decode(json_content)
    {:ok, timestamp} = HashDict.fetch(json_hash, "lastUpdate")
    reading_datetime = timestamp_datetime(timestamp)

    existing_reading_station_ids = ReadingQuery.timestamp_station_ids(reading_datetime)
    {:ok, results} = HashDict.fetch(json_hash, "results")
    meta = {reading_datetime, existing_reading_station_ids}
    {r, i} = ReadingImporter.import_results(results, meta)
    index + 1
  end

  defp timestamp_datetime(timestamp) do
    erl_base_datetime = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
    timestamp |> + erl_base_datetime |> :calendar.gregorian_seconds_to_datetime |> Ecto.DateTime.from_erl
  end
end
