defmodule CbstatsImporter.ParallelImporter do
  defrecord Callback, fun: nil, last_result: nil

  def import(files, callback_fun) do
    callback = Callback.new fun: callback_fun
    spawn_importers(files, [], callback)
  end

  # We already have 4 currently running, don't spawn new ones
  defp spawn_importers(files, queued, callback) when
      length(queued) >= 4 do
    # IO.puts "We already have 4 currently running, don't spawn new ones"
    wait_for_messages(files, queued, callback)
  end

  # Spawn a compiler for each file in the list until we reach the limit
  defp spawn_importers([h|t], queued, callback) do
    # IO.puts "Spawn a compiler for each file in the list until we reach the limit"
    parent = Process.self()

    child = spawn_link fn ->
      try do
        {:ok, 1} = CbstatsImporter.ImportProcess.import_path(h)
        send parent, { :imported, Process.self(), h }
      catch
        kind, reason ->
          send parent, { :failure, Process.self(), kind, reason, System.stacktrace }
      end
    end

    spawn_importers(t, [{child,h}|queued], callback)
  end

  # No more files, nothing waiting, queue is empty, we are done
  defp spawn_importers([], [], callback) do
    # IO.puts "No more files, nothing waiting, queue is empty, we are done"
    :done
  end

  # No more files, but queue and waiting are not full or do not match
  defp spawn_importers([], queued, callback) do
    # IO.puts "No more files, but queue and waiting are not full or do not match"
    wait_for_messages([], queued, callback)
  end

  # Wait for messages from child processes
  defp wait_for_messages(files, queued, callback) do
    receive do
      { :imported, child, file } ->
        new_queued  = List.keydelete(queued, child, 0)
        result = callback.fun.(file, callback.last_result)
        new_callback = callback.update(last_result: result)
        spawn_importers(files, new_queued, new_callback)
      { :failure, child, kind, reason, stacktrace } ->
        IO.puts "child: failure"

      {^child, file} = List.keyfind(queued, child, 1)
      IO.puts "== Compilation error on file #{file} =="
      Erlang.erlang.raise(kind, reason, stacktrace)
    end
  end
end
