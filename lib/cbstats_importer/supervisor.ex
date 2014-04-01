defmodule CbstatsImporter.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      # worker(CbstatsImporter.Worker, [])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)

    # Repo configuration
    tree = [ worker(Repo, []) ]
    supervise(tree, strategy: :one_for_all)
  end
end
