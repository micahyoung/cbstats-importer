defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Import Readings"

  @moduledoc """
  Import readings
  """

  def run(args) do
    Mix.Task.run "app.start", []

    options = elem OptionParser.parse(args, switches: [processes: :integer]), 0
    data_root = options[:path] || "data/json"
    child_count = options[:processes] || :erlang.system_info(:schedulers_online)

    files = Path.wildcard(Path.join(data_root, "*"))
    CbstatsImporter.ParallelImporter.import(files)
  end
end

