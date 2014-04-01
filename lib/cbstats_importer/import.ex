defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", args

    json_paths = Path.wildcard("data/json/*.json")
    Enum.each json_paths, fn(path) -> import_json_path(path) end
  end

  defp import_json_path(json_path) do
      {:ok, json_content} = File.read(json_path)
      {:ok, json_hash} = JSON.decode(json_content)
      {:ok, timestamp} = HashDict.fetch(json_hash, "lastUpdate")
      reading_datetime = timestamp_datetime(timestamp)

      existing_reading_station_ids = ReadingQuery.timestamp_station_ids(reading_datetime)
      {:ok, results} = HashDict.fetch(json_hash, "results")

      Enum.each results, fn(result) ->
        if !Enum.member?(existing_reading_station_ids, result["id"]) do
          reading = Reading.new [
            station_id: result["id"],
            taken_at: reading_datetime,
            status: result["status"],
            available_bikes: result["availableBikes"],
            available_docks: result["availableDocks"],
            created_at: Ecto.DateTime.from_erl(:calendar.universal_time()),
            updated_at: Ecto.DateTime.from_erl(:calendar.universal_time())
          ]
          Repo.create(reading)
        end
      end
    end

  defp timestamp_datetime(timestamp) do
    #TODO: convert to expression
    erl_base_datetime = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
    seconds = erl_base_datetime + timestamp
    erl_datetime = :calendar.gregorian_seconds_to_datetime(seconds)
    Ecto.DateTime.from_erl(erl_datetime)
  end
end
