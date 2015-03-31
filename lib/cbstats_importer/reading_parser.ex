defmodule CbstatsImporter.ReadingParser do
  def parse_json(json_content) do
    {:ok, json_hash} = Poison.decode(json_content)
    {:ok, timestamp} = Map.fetch(json_hash, "lastUpdate")
    reading_datetime = timestamp_datetime(timestamp)

    {:ok, results} = Map.fetch(json_hash, "results")
    {reading_datetime, results}
  end

  defp timestamp_datetime(timestamp) do
    erl_base_datetime = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
    dt = timestamp |> + erl_base_datetime |> :calendar.gregorian_seconds_to_datetime |> erl_load
    dt
  end

  defp erl_load({{year, month, day}, {hour, min, sec}}) do
    %Ecto.DateTime{year: year, month: month, day: day,
                   hour: hour, min: min, sec: sec}
  end

end
