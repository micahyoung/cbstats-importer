defmodule CbstatsImporter.ReadingImporter do
  def import_results([result|remaining_results], reading_datetime, existing_reading_station_ids, readings) do
    if !Enum.member?(existing_reading_station_ids, result["id"]) do
      new_reading = %CbstatsImporter.Reading{
        station_id: result["id"],
        taken_at: reading_datetime,
        status: result["status"],
        available_bikes: result["availableBikes"],
        available_docks: result["availableDocks"],
        created_at: CbstatsImporter.Util.now_datetime,
        updated_at: CbstatsImporter.Util.now_datetime
      }
      new_readings = [new_reading|readings]
    else
      new_readings = readings
    end

    import_results(remaining_results, reading_datetime, existing_reading_station_ids, new_readings)
  end

  def import_results([], reading_datetime, _existing_reading_station_ids, readings) do
    insertable_readings = List.flatten readings

    CbstatsImporter.Repo.transaction fn ->
      Enum.each insertable_readings, fn(reading) ->
        CbstatsImporter.Repo.insert(reading)
      end
    end
  end
end
