defmodule CbstatsImporter.Util do
  def now_microseconds do
    {megas, secs, millis} = :os.timestamp()
    ((megas * 1_000_000) + secs) * 1_000_000 + millis
  end

  def now_datetime do
    Ecto.DateTime.utc
  end
end
