defmodule CbstatsImporter.Util do
  def now_seconds do
    :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds
  end
end

