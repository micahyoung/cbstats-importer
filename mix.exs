defmodule CbstatsImporter.Mixfile do
  use Mix.Project

  def project do
    [ app: :cbstats_importer,
      version: "0.0.1",
      elixir: "~> 1.0",
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
    [ {:ecto, "~> 0.2.5", git: "https://github.com/elixir-lang/ecto", tag: "v0.2.5"},
      {:postgrex, "~> 0.6.0", override: true, git: "https://github.com/ericmj/postgrex", tag: "v0.6.0"},
      {:poison, "~> 1.2.0", git: "https://github.com/devinus/poison", tag: "1.2.0"} ]
  end
end
