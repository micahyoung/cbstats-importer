defmodule CbstatsImporter.ReadingDay do
  use Ecto.Model

  queryable "reading_days" do
    field :taken_at_date, :date
    field :created_at, :datetime
    field :updated_at, :datetime
  end
end
