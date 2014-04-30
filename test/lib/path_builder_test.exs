defmodule CbstatsImporterTest.PathBuilder do
  use ExUnit.Case

  setup do
    drop_fixtures
    create_fixtures
  end

  test ".path_chunks" do
    path_wildcard = "test/fixtures/temp/*"
    chunk_count = 3
    assert CbstatsImporter.PathBuilder.chunk_paths(path_wildcard, chunk_count) == [
      ["test/fixtures/temp/0.json",
       "test/fixtures/temp/3.json",
       "test/fixtures/temp/6.json",
       "test/fixtures/temp/9.json"],
      ["test/fixtures/temp/1.json",
       "test/fixtures/temp/4.json",
       "test/fixtures/temp/7.json"],
      ["test/fixtures/temp/2.json",
       "test/fixtures/temp/5.json",
       "test/fixtures/temp/8.json"]
    ]
  end

  teardown do
    drop_fixtures
  end

  defp create_fixtures do
    File.mkdir_p!("test/fixtures/temp/")
    Enum.map(0..9, &(File.touch!("test/fixtures/temp/#{&1}.json")))
    :ok
  end

  defp drop_fixtures do
    File.rm_rf!("test/fixtures/temp/")
    :ok
  end
end
