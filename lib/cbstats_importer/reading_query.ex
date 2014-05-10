defmodule CbstatsImporter.ReadingQuery do
  import Ecto.Query

  def timestamp_station_ids(reading_datetime) do
    query = from r in CbstatsImporter.Reading,
      where: r.taken_at == ^reading_datetime,
      select: r.station_id

    CbstatsImporter.Repo.all(query)
  end

  def find_or_create_reading_day(date) do
    query = from d in CbstatsImporter.ReadingDay,
      where: d.taken_at_date == ^date

    case CbstatsImporter.Repo.all(query) do
      [reading_day] ->
        reading_day
      [] ->
        reading_day = CbstatsImporter.ReadingDay.new [taken_at_date: date]
        CbstatsImporter.Repo.insert(reading_day)
    end
  end

  def reading_day_date_id_dict do
    query = from d in CbstatsImporter.ReadingDay,
      select: [d.taken_at_date, d.id]

    reading_days = CbstatsImporter.Repo.all(query)

    Enum.reduce reading_days, HashDict.new, fn(reading_day, day_dict) ->
      HashDict.put(day_dict, List.first(reading_day), List.last(reading_day))
    end
  end
end
