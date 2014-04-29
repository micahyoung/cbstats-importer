defmodule CbstatsImporterTest.PathBuilder do
  use ExUnit.Case

  setup do
    drop_fixtures

    Enum.map Enum.to_list(0..9), fn(index) ->
      File.touch!("test/fixtures/#{index}.json")
    end

    :ok
  end

  test "the truth" do
    path_wildcard = "test/fixtures/*"
    assert CbstatsImporter.PathBuilder.chunk_paths(path_wildcard, 3) == [
      ["test/fixtures/0.json",
       "test/fixtures/3.json",
       "test/fixtures/6.json",
       "test/fixtures/9.json"],
      ["test/fixtures/1.json",
       "test/fixtures/4.json",
       "test/fixtures/7.json"],
      ["test/fixtures/2.json",
       "test/fixtures/5.json",
       "test/fixtures/8.json"]
    ]
  end

  teardown do
    drop_fixtures
  end

  defp drop_fixtures do
    fixtures = Path.wildcard("test/fixtures/*")
    Enum.each(fixtures, &(File.rm!(&1)))
    :ok
  end
end
