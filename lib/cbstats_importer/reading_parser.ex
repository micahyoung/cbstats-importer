defmodule CbstatsImporter.ReadingParser do
  def parse_json_file(json_path) do
    {:ok, json_content} = File.read(json_path)
    {:ok, json_hash} = JSON.decode(json_content)
    {:ok, timestamp} = HashDict.fetch(json_hash, "lastUpdate")
    reading_datetime = timestamp_datetime(timestamp)

    {:ok, results} = HashDict.fetch(json_hash, "results")
    {reading_datetime, results}
  end

  defp timestamp_datetime(timestamp) do
    erl_base_datetime = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
    timestamp |> + erl_base_datetime |> :calendar.gregorian_seconds_to_datetime |> Ecto.DateTime.from_erl
  end
end
