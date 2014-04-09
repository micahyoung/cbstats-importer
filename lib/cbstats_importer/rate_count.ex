defmodule RateCount do
  defrecord Counter, paths_done: nil, total_paths: nil, last_paths_done: nil, last_seconds: nil

  def init(total_paths) do
    Counter.new [paths_done: 0, total_paths: total_paths, last_paths_done: 0, last_seconds: Util.now_seconds]
  end

  def update(counter) do
    elapsed_seconds = Util.now_seconds - counter.last_seconds
    if elapsed_seconds > 3 do
      elapsed_records = counter.paths_done - counter.last_paths_done
      rate = Float.floor(elapsed_records / elapsed_seconds)
      percent = Float.floor(100 * counter.paths_done / counter.total_paths)
      IO.puts "#{rate} files/s (#{percent}%)"

      last_seconds = Util.now_seconds
      last_paths_done = counter.paths_done
    else
      last_seconds = counter.last_seconds
      last_paths_done = counter.last_paths_done
    end

    Counter.new [paths_done: counter.paths_done + 1, total_paths: counter.total_paths, last_paths_done: last_paths_done, last_seconds: last_seconds]
  end
end

