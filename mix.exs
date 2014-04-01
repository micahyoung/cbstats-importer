defmodule CbstatsImporter.Mixfile do
  use Mix.Project

  def project do
    [ app: :cbstats_importer,
      version: "0.0.1",
      elixir: "~> 0.12.5",
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
    [{ :postgrex, github: "ericmj/postgrex" },
     { :json, github: "cblage/elixir-json" },
     { :ecto, github: "elixir-lang/ecto" }]
  end
end
