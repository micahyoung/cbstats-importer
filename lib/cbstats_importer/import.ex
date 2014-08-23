defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", []

    options = elem(OptionParser.parse(args, switches: [processes: :integer]), 0)
    data_root = options[:path] || "data/json"

    files = Path.wildcard(Path.join(data_root, "*"))

    import_stations(files)
    import_readings(files)
  end

  def import_stations(files) do
    child_fun = fn(file_path) ->
      {:ok, json_content} = File.read(file_path)
      {_reading_datetime, results} = CbstatsImporter.ReadingParser.parse_json(json_content)
      station_hash = Enum.reduce(results, HashDict.new, fn(x, acc) -> HashDict.put(acc, x["id"], Map.take(x, ["latitude", "longitude", "label"])) end)

      {:ok, station_hash}
    end

    callback_fun = fn(new_station_dict, acc) ->
      {acc_station_dict, last_counter} = acc || {nil, nil}
      station_dict = HashDict.merge acc_station_dict || HashDict.new, new_station_dict

      update_counter = last_counter || CbstatsImporter.RateCount.init(length(files))
      new_counter = CbstatsImporter.RateCount.update(update_counter)

      {:ok, {station_dict, new_counter}}
    end

    {:done, {full_station_dict, _counter}} = CbstatsImporter.ParallelImporter.import(files, child_fun, callback_fun)

    existing_station_ids = CbstatsImporter.StationQuery.station_ids
    CbstatsImporter.StationImporter.import_stations(full_station_dict, existing_station_ids)
  end

  def import_readings(files) do
    child_fun = fn(file_path) ->
      {:ok, json_content} = File.read(file_path)
      CbstatsImporter.ImportProcess.import_reading_json(json_content)

      {:ok, nil}
    end

    callback_fun = fn(_file, last_counter) ->
      update_counter = last_counter || CbstatsImporter.RateCount.init(length(files))
      new_counter = CbstatsImporter.RateCount.update(update_counter)

      {:ok, new_counter}
    end
    CbstatsImporter.ParallelImporter.import(files, child_fun, callback_fun)
  end
end

