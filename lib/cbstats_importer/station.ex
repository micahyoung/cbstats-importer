defmodule Station do
  use Ecto.Model

  queryable "stations" do
    has_many :readings, Reading
    field :latitude, :float
    field :longitude, :float
    field :label, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end
end
