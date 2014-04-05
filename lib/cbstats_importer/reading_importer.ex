defmodule ReadingImporter do
  def import_results([result|remaining_results], meta) do
    {reading_datetime, existing_reading_station_ids} = meta

    if !Enum.member?(existing_reading_station_ids, result["id"]) do
      reading = Reading.new [
        station_id: result["id"],
        taken_at: reading_datetime,
        status: result["status"],
        available_bikes: result["availableBikes"],
        available_docks: result["availableDocks"],
        created_at: now_datetime,
        updated_at: now_datetime
      ]
      Repo.create(reading)
    end

    next_meta = {reading_datetime, existing_reading_station_ids}
    import_results(remaining_results, next_meta)
  end

  def import_results([], meta) do
    meta
  end

  defp now_datetime do
    Ecto.DateTime.from_erl(:calendar.universal_time())
  end
end

