defmodule CbstatsImporter.Repo.Migrations.CreateTimestamps do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE timestamps (
        id serial NOT NULL,
        taken_at timestamp without time zone,
        total_active_bikes integer,
        created_at timestamp without time zone,
        updated_at timestamp without time zone
    );
    """
  end

  def down do
    """
    DROP TABLE timestamps;
    """
  end
end
