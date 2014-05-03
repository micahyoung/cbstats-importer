defmodule CbstatsImporter.ReadingImporter do
  def import_results([result|remaining_results], reading_datetime, existing_reading_station_ids, readings) do
    if !Enum.member?(existing_reading_station_ids, result["id"]) do
      new_reading = CbstatsImporter.Reading.new [
        station_id: result["id"],
        taken_at: reading_datetime,
        status: result["status"],
        available_bikes: result["availableBikes"],
        available_docks: result["availableDocks"],
        created_at: now_datetime,
        updated_at: now_datetime
      ]
      new_readings = [new_reading|readings]
    else
      new_readings = readings
    end

    import_results(remaining_results, reading_datetime, existing_reading_station_ids, new_readings)
  end

  def import_results([], _reading_datetime, _existing_reading_station_ids, readings) do
    insertable_readings = List.flatten readings

    if length(insertable_readings) > 0 do
      CbstatsImporter.Repo.insert_entities(insertable_readings)
    end
  end

  defp now_datetime do
    Ecto.DateTime.from_erl(:calendar.universal_time())
  end
end
