defmodule CbstatsImporter.Mixfile do
  use Mix.Project

  def project do
    [ app: :cbstats_importer,
      version: "0.0.1",
      elixir: "~> 0.15.0",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { CbstatsImporter, [] },
      applications: [:postgrex, :ecto]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [ { :postgrex, "~> 0.5.0", github: "ericmj/postgrex", override: true },
      { :ecto, github: "elixir-lang/ecto" },
      { :json, github: "cblage/elixir-json" } ]
  end
end
