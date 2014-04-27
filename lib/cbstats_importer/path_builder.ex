defmodule CbstatsImporter.PathBuilder do
  def chunk_paths(path_wildcard, chunk_count) do
    paths = Path.wildcard(path_wildcard)
    path_count = Enum.count(paths)
    items_per_chunk = Float.ceil(path_count/chunk_count)
    Enum.chunk(Enum.shuffle(paths), items_per_chunk, items_per_chunk, [])
  end
end
