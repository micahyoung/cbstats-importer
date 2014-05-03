defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", []

    options = elem(OptionParser.parse(args), 0)
    data_root = options[:path] || "data/json"

    files = Path.wildcard(Path.join(data_root, "*"))
    callback_fun = fn(_file, last_counter) ->
      update_counter = last_counter || CbstatsImporter.RateCount.init(length(files))
      CbstatsImporter.RateCount.update(update_counter)
    end
    CbstatsImporter.ParallelImporter.import(files, callback_fun)
  end
end

