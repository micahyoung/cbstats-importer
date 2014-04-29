defmodule CbstatsImporter.PathBuilder do
  def chunk_paths(path_wildcard, chunk_count) do
    paths = Path.wildcard(path_wildcard)

    paths |> chunk_index(chunk_count) |> chunk_sort |> chunk |> strip_index
  end

  defp chunk_index(paths, chunk_count) do
    Enum.map(Enum.with_index(paths), fn({k, v}) -> {k, rem(v, chunk_count)} end)
  end

  defp chunk_sort(chunk_indexed_paths) do
    Enum.sort(chunk_indexed_paths, fn({_, v1}, {_, v2}) -> v1 <= v2 end)
  end

  defp chunk(chunk_sorted_indexed_paths) do
    Enum.chunk_by(chunk_sorted_indexed_paths, fn({_, v})-> v end)
  end

  def strip_index(chunked_index_paths) do
    Enum.map chunked_index_paths, fn(index_paths) ->
      Enum.map(index_paths, &(elem(&1, 0)))
    end
  end
end
