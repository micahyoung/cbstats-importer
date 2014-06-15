defmodule CbstatsImporter.Timestamp do
  use Ecto.Model

  schema "timestamps" do
    field :taken_at, :datetime
    field :total_active_bikes, :integer
    field :created_at, :datetime
    field :updated_at, :datetime
  end
end
