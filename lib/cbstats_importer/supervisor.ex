defmodule CbstatsImporter.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    tree = [ worker(CbstatsImporter.Repo, []) ]
    supervise(tree, strategy: :one_for_all)
  end
end
