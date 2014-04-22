defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  defrecord PartitionSet, partitions: HashSet.new
  defrecord PathPartition, paths: HashSet.new, paths_scanned: 0

  def run(args) do
    Mix.Task.run "app.start", args
    child_count = 4

    json_paths = Path.wildcard("data/json/*.json")
    path_count = Enum.count(json_paths)
    items_per_chunk = Float.ceil(path_count/child_count)
    path_chunks = Enum.chunk(Enum.shuffle(json_paths), items_per_chunk, items_per_chunk, [])

    Enum.each path_chunks, fn(paths) ->
      child = spawn(fn -> CbstatsImporter.ImportProcess.import_loop() end)
      send(child, {:import_paths, paths})
    end
  end
end

