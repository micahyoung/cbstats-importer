defmodule CbstatsImporter.RateCount do
  defmodule Counter do
    defstruct paths_done: nil, total_paths: nil, last_paths_done: nil, last_micros: nil
  end

  def init(total_paths) do
    %Counter{paths_done: 0, total_paths: total_paths, last_paths_done: 0, last_micros: CbstatsImporter.Util.now_microseconds}
  end

  def update(counter) do
    elapsed_micros = CbstatsImporter.Util.now_microseconds - counter.last_micros
    percent = get_percent(counter.paths_done, counter.total_paths)
    if elapsed_micros > 3_000_000 || percent == 100 do
      elapsed_records = counter.paths_done - counter.last_paths_done
      rate = get_rate(elapsed_records, elapsed_micros)
      Mix.shell.info "[#{percent}%] #{rate} files/s "

      last_micros = CbstatsImporter.Util.now_microseconds
      last_paths_done = counter.paths_done
    else
      last_micros = counter.last_micros
      last_paths_done = counter.last_paths_done
    end

    struct(counter, [paths_done: counter.paths_done + 1, total_paths: counter.total_paths, last_paths_done: last_paths_done, last_micros: last_micros])
  end

  defp get_percent(current_count, total_count) do
    round(100 * (current_count + 1) / total_count)
  end

  defp get_rate(elapsed_records, elapsed_micros) do
    round(elapsed_records / (elapsed_micros / 1_000_000))
  end
end

