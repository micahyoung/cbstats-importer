defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", args
    child_count = 4

    json_paths = Path.wildcard("data/json/*.json")
    path_count = Enum.count(json_paths)

    counter = CbstatsImporter.RateCount.init(path_count / child_count)
    children = Enum.map Range.new(1, child_count), fn(_) ->
      spawn(fn -> CbstatsImporter.Importer.import_loop(counter) end)
    end

    Enum.each json_paths, fn(path) ->
      child = Enum.at(children, :random.uniform(child_count)-1)
      send(child, {:import_path, path})
    end
  end
end
