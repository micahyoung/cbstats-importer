defmodule CbstatsImporter.ParallelImporter do
  defmodule Record do
    defstruct child_fun: nil, callback_fun: nil, callback_acc: nil
  end

  defmacro process_count do
    quote do: unquote(:erlang.system_info(:schedulers_online) |> Kernel.*(1.5) |> Float.floor)
  end

  def import(files, child_fun, callback_fun) do
    record = %Record{child_fun: child_fun, callback_fun: callback_fun}
    spawn_importers(files, [], record)
  end

  # We already have one child-per-core running, don't spawn new ones
  defp spawn_importers(files, queued, record) when
      length(queued) >= process_count do
    wait_for_messages(files, queued, record)
  end

  # Spawn a child for each file in the list until we reach the limit
  defp spawn_importers([h|t], queued, record) do
    parent = self()

    child = spawn_link fn ->
      try do
        {:ok, result} = record.child_fun.(h)
        send parent, { :imported, self(), result }
      catch
        kind, reason ->
          send parent, { :failure, self(), h, kind, reason, System.stacktrace }
      end
    end

    spawn_importers(t, [{child,h}|queued], record)
  end

  # No more files, nothing waiting, queue is empty, we are done
  defp spawn_importers([], [], record) do
    {:done, record.callback_acc}
  end

  # No more files, but queue and waiting are not full or do not match
  defp spawn_importers([], queued, record) do
    wait_for_messages([], queued, record)
  end

  # Wait for messages from child processes
  defp wait_for_messages(files, queued, record) do
    receive do
      { :imported, child, result } ->
        new_queued  = List.keydelete(queued, child, 0)
        {:ok, new_acc} = record.callback_fun.(result, record.callback_acc)
        new_record = struct(record, [callback_acc: new_acc])
        spawn_importers(files, new_queued, new_record)
      { :failure, child, file, kind, reason, stacktrace } ->
        IO.puts "failure for file #{file} on child: #{inspect child}"
        :erlang.raise(kind, reason, stacktrace)
    end
  end
end
