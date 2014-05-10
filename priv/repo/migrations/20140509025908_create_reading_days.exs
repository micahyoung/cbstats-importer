defmodule CbstatsImporter.Repo.Migrations.CreateReadingDays do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE reading_days (
        id serial NOT NULL,
        taken_at_date date,
        created_at timestamp without time zone,
        updated_at timestamp without time zone
    );
    """
  end

  def down do
    """
    DROP TABLE reading_days;
    """
  end
end
