defmodule CbstatsImporter.Repo.Migrations.CreateReadings do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE readings (
        id serial NOT NULL,
        station_id integer,
        status character varying(255),
        available_bikes integer,
        available_docks integer,
        taken_at timestamp without time zone,
        created_at timestamp without time zone,
        updated_at timestamp without time zone
    );
    """
  end

  def down do
    """
    DROP TABLE readings;
    """
  end
end
