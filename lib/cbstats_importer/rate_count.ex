defmodule CbstatsImporter.RateCount do
  defrecord Counter, paths_done: nil, total_paths: nil, last_paths_done: nil, last_seconds: nil

  def init(total_paths) do
    Counter.new [paths_done: 0, total_paths: total_paths, last_paths_done: 0, last_seconds: CbstatsImporter.Util.now_seconds]
  end

  def update(counter) do
    elapsed_seconds = CbstatsImporter.Util.now_seconds - counter.last_seconds
    percent = Float.floor(100 * counter.paths_done / counter.total_paths)
    if elapsed_seconds > 3 || percent >= 100 do
      elapsed_records = counter.paths_done - counter.last_paths_done

      if elapsed_seconds > 0 do
        rate = Float.floor(elapsed_records / elapsed_seconds)
        IO.puts "[#{percent}%] #{rate} files/s "
      end

      last_seconds = CbstatsImporter.Util.now_seconds
      last_paths_done = counter.paths_done
    else
      last_seconds = counter.last_seconds
      last_paths_done = counter.last_paths_done
    end

    Counter.new [paths_done: counter.paths_done + 1, total_paths: counter.total_paths, last_paths_done: last_paths_done, last_seconds: last_seconds]
  end
end

