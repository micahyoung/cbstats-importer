defmodule CbstatsImporter.Util do
  def now_microseconds do
    {megas, secs, millis} = :os.timestamp()
    ((megas * 1_000_000) + secs) * 1_000_000 + millis
  end

  def now_datetime do
    :calendar.universal_time |> Ecto.DateTime.from_erl
  end

  def datetime_to_date(datetime) do
    datetime.to_erl |> elem(0) |> Ecto.Date.from_erl
  end
end
