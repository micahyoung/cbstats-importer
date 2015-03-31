defmodule CbstatsImporter.Station do
  use Ecto.Model

  schema "stations" do
    has_many :readings, CbstatsImporter.Reading
    field :latitude, :float
    field :longitude, :float
    field :label, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end
