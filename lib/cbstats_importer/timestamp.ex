defmodule CbstatsImporter.Timestamp do
  use Ecto.Model

  schema "timestamps" do
    field :taken_at, Ecto.DateTime
    field :total_active_bikes, :integer
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end
