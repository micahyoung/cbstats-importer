defmodule Reading do
  use Ecto.Model

  queryable "readings" do
    belongs_to :station, Station
    field :status, :string
    field :available_bikes, :integer
    field :available_docks, :integer
    field :taken_at, :datetime
    field :created_at, :datetime
    field :updated_at, :datetime
  end
end
