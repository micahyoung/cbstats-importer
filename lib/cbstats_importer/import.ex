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
      stations_hash = Enum.reduce(results, HashDict.new, fn(x, acc) -> HashDict.put(acc, x["id"], Map.take(x, ["latitude", "longitude", "label"])) end)

      {:ok, stations_hash}
    end

    callback_fun = fn(new_station_dict, acc) ->
      {acc_station_ids, last_counter} = acc || {Enum.into(CbstatsImporter.StationQuery.station_ids, HashSet.new), nil}

      new_station_ids = Enum.into HashDict.keys(new_station_dict), HashSet.new
      if HashSet.equal?(acc_station_ids, new_station_ids) do
        next_station_ids = acc_station_ids
      else
        next_station_ids = HashSet.union(acc_station_ids, new_station_ids)
        CbstatsImporter.StationImporter.import_stations(new_station_dict, acc_station_ids)
      end

      update_counter = last_counter || CbstatsImporter.RateCount.init(length(files))
      new_counter = CbstatsImporter.RateCount.update(update_counter)

      {:ok, {next_station_ids, new_counter}}
    end

    {:done, _} = CbstatsImporter.ParallelImporter.import(files, child_fun, callback_fun)
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
    {:done, _} = CbstatsImporter.ParallelImporter.import(files, child_fun, callback_fun)
  end
end

