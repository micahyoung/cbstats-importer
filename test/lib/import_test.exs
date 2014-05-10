defmodule CbstatsImporterTest.Mix.Tasks.Import do
  import Ecto.Query
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup do
    drop_readings
    :ok
  end

  test ".run" do
    assert capture_io(fn ->
      Mix.Tasks.Import.run(["--path", "test/fixtures/data/json"])
    end) =~ ~r{\[100%\] \d* files/s}

    reading_day_query = from d in CbstatsImporter.ReadingDay, select: d
    [reading_day] = CbstatsImporter.Repo.all(reading_day_query)
    assert = reading_day.taken_at_date Ecto.Date[year: 2014, month: 1, day: 7]

    reading_query = from r in CbstatsImporter.Reading, select: r, order_by: [asc: r.taken_at, asc: r.station_id]
    readings = CbstatsImporter.Repo.all(reading_query)
    r1 = Enum.at(readings, 0)
    assert r1.station_id ==  1
    assert r1.status ==  "Active"
    assert r1.available_bikes ==  5
    assert r1.available_docks ==  10
    assert r1.taken_at ==  Ecto.DateTime[year: 2014, month: 1, day: 7, hour: 3, min: 29, sec: 16]

    r2 = Enum.at(readings, 1)
    assert r2.station_id ==  2
    assert r2.status ==  "Active"
    assert r2.available_bikes ==  15
    assert r2.available_docks ==  20
    assert r2.taken_at ==  Ecto.DateTime[year: 2014, month: 1, day: 7, hour: 3, min: 29, sec: 16]

    r3 = Enum.at(readings, 2)
    assert r3.station_id ==  1
    assert r3.status ==  "Active"
    assert r3.available_bikes ==  25
    assert r3.available_docks ==  30
    assert r3.taken_at ==  Ecto.DateTime[year: 2014, month: 1, day: 7, hour: 3, min: 59, sec: 17]

    r4 = Enum.at(readings, 3)
    assert r4.station_id ==  2
    assert r4.status ==  "Active"
    assert r4.available_bikes ==  35
    assert r4.available_docks ==  40
    assert r4.taken_at ==  Ecto.DateTime[year: 2014, month: 1, day: 7, hour: 3, min: 59, sec: 17]
  end

  teardown do
    drop_readings
    :ok
  end

  defp drop_readings do
    query = from CbstatsImporter.Reading, where: true
    CbstatsImporter.Repo.delete_all(query)
    query = from CbstatsImporter.ReadingDay, where: true
    CbstatsImporter.Repo.delete_all(query)
    :ok
  end
end
