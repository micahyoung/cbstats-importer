defmodule CbstatsImporter.Server.Server do
  use GenServer.Behaviour

  def start_link(stack) do
    :gen_server.start_link({ :local, :cbstats_importer }, __MODULE__, stack, [])
  end

  def init(stack) do
    { :ok, stack }
  end

  def handle_call({:import, callback_fun}, _from, _stack) do
    result = callback_fun.()
    { :reply, result, nil }
  end
end
