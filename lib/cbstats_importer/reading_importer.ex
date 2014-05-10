defmodule CbstatsImporter.ReadingImporter do
  def import_results([result|remaining_results], reading_datetime, existing_reading_station_ids, reading_day_date_id_dict, readings \\ []) do
    if !Enum.member?(existing_reading_station_ids, result["id"]) do
      reading_date = CbstatsImporter.Util.datetime_to_date(reading_datetime)
      reading_day_id = HashDict.get(reading_day_date_id_dict, reading_date)

      new_reading = CbstatsImporter.Reading.new [
        reading_day_id: reading_day_id,
        station_id: result["id"],
        taken_at: reading_datetime,
        status: result["status"],
        available_bikes: result["availableBikes"],
        available_docks: result["availableDocks"],
        created_at: CbstatsImporter.Util.now_datetime,
        updated_at: CbstatsImporter.Util.now_datetime
      ]
      new_readings = [new_reading|readings]
    else
      new_readings = readings
    end

    import_results(remaining_results, reading_datetime, existing_reading_station_ids, reading_day_date_id_dict, new_readings)
  end

  def import_results([], _reading_datetime, _existing_reading_station_ids, reading_day_date_id_dict, readings) do
    insertable_readings = List.flatten readings

    if length(insertable_readings) > 0 do
      CbstatsImporter.Repo.insert_entities(insertable_readings)
    end
  end
end
