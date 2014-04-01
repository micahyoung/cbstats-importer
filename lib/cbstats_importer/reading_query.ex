defmodule ReadingQuery do
  import Ecto.Query

  def timestamp_station_ids(reading_datetime) do
    query = from r in Reading,
      where: r.taken_at == ^reading_datetime,
      select: r.station_id

    Repo.all(query)
  end

end
