defmodule CbstatsImporter.Repo.Migrations.AddReadingDayIdToReadings do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE readings ADD COLUMN reading_day_id integer;
    """
  end

  def down do
    """
    ALTER TABLE readings REMOVE COLUMN reading_day_id;
    """
  end
end
