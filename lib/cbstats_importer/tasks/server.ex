defmodule Mix.Tasks.Serve do
  use Mix.Task

  @shortdoc "Import Server"

  @moduledoc """
  Import server
  """

  def run(args) do
    Mix.Task.run "app.start", []

    CbstatsImporter.Server.Server.start_link([:hello])
    callback_fun = fn() -> :hi end
    :gen_server.call(:cbstats_importer, {:import, callback_fun})
  end
end

