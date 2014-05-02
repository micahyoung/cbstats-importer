defmodule CbstatsImporter.ParallelImporter do
  def import(files) do
    counter = CbstatsImporter.RateCount.init(length files)
    spawn_importers(files, [], counter)
  end

  # We already have 4 currently running, don't spawn new ones
  defp spawn_importers(files, queued, counter) when
      length(queued) >= 4 do
    # IO.puts "We already have 4 currently running, don't spawn new ones"
    wait_for_messages(files, queued, counter)
  end

  # Spawn a compiler for each file in the list until we reach the limit
  defp spawn_importers([h|t], queued, counter) do
    # IO.puts "Spawn a compiler for each file in the list until we reach the limit"
    parent = Process.self()

    child  = spawn_link fn ->
      try do
        {:ok, 1} = CbstatsImporter.ImportProcess.import_path(h)
        send parent, { :imported, Process.self(), h }
      catch
        kind, reason ->
          send parent, { :failure, Process.self(), kind, reason, System.stacktrace }
      end
    end

    spawn_importers(t, [{child,h}|queued], counter)
  end

  # No more files, nothing waiting, queue is empty, we are done
  defp spawn_importers([], [], counter) do
    # IO.puts "No more files, nothing waiting, queue is empty, we are done"
    :done
  end

  # No more files, but queue and waiting are not full or do not match
  defp spawn_importers([], queued, counter) do
    # IO.puts "No more files, but queue and waiting are not full or do not match"
    wait_for_messages([], queued, counter)
  end

  # Wait for messages from child processes
  defp wait_for_messages(files, queued, counter) do
    receive do
      { :imported, child, file } ->
        new_queued  = List.keydelete(queued, child, 0)
        # Sometimes we may have spurious entries in the waiting
        # list because someone invoked try/rescue UndefinedFunctionError
        new_counter = CbstatsImporter.RateCount.update(counter)
        spawn_importers(files, new_queued, new_counter)
      { :failure, child, kind, reason, stacktrace } ->
        IO.puts "child: failure"

      {^child, file} = List.keyfind(queued, child, 1)
      IO.puts "== Compilation error on file #{file} =="
      Erlang.erlang.raise(kind, reason, stacktrace)
    end
  end
end
