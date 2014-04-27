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
    items_per_chunk = Float.ceil(path_count/child_count)
    path_chunks = Enum.chunk(Enum.shuffle(json_paths), items_per_chunk, items_per_chunk, [])

    parent = Process.self()

    children = Enum.map path_chunks, fn(paths) ->
      spawn_link(fn ->
        CbstatsImporter.ImportProcess.import_paths(paths)
        send parent, { :imported, Process.self() }
      end)
    end

    wait_for_children(children)
  end

  def wait_for_children([]) do
    IO.puts "DONE"
  end

  def wait_for_children(children) do
    receive do
      {:imported, child} -> 
        remaining_children = Enum.reject children, fn(c) ->
          child == c
        end

        wait_for_children(remaining_children)
    end
  end
end

