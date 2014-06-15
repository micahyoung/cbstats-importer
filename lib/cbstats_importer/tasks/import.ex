defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", []

    options = elem(OptionParser.parse(args, switches: [processes: :integer]), 0)
    data_root = options[:path] || "data/json"

    files = Path.wildcard(Path.join(data_root, "*"))
    child_fun = fn(file) ->
      CbstatsImporter.ImportProcess.import_path(file)
      {:ok, nil}
    end
    callback_fun = fn(_file, last_counter) ->
      update_counter = last_counter || CbstatsImporter.RateCount.init(length(files))
      new_counter = CbstatsImporter.RateCount.update(update_counter)
      {:ok, new_counter}
    end
    CbstatsImporter.ParallelImporter.import(files, child_fun, callback_fun)
  end
end
