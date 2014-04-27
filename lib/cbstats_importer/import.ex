defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", args
    child_count = :erlang.system_info(:schedulers_online)
    path_chunks = CbstatsImporter.PathBuilder.chunk_paths("data/json/*.json", child_count)

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
        remaining_children = Enum.reject children, &(&1 == child)
        wait_for_children(remaining_children)
    end
  end
end

