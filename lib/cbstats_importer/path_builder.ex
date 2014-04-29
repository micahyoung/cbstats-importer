defmodule CbstatsImporter.PathBuilder do
  def chunk_paths(path_wildcard, chunk_count) do
    paths = Path.wildcard(path_wildcard)
    indexed_paths = Enum.with_index(paths)

    chunk_sorted_indexed_paths = Enum.sort(indexed_paths, &(indexed_path_compare(&1, &2, chunk_count)))
    chunked_index_paths = Enum.chunk_by(chunk_sorted_indexed_paths, &(rem(elem(&1, 1), chunk_count)))

    Enum.map chunked_index_paths, fn(index_paths) ->
      Enum.map(index_paths, &(elem(&1, 0)))
    end
  end

  defp path_index_path(path) do
    name = File.rootname(File.basename(path))
  end

  defp indexed_path_compare(path1, path2, chunk_count) do
    rem(elem(path1, 1), chunk_count) <= rem(elem(path2, 1), chunk_count)
  end
end
