defmodule CbstatsImporter.Repo.Migrations.CreateStations do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE stations (
      id serial NOT NULL,
      latitude double precision,
      longitude double precision,
      label character varying(255),
      created_at timestamp without time zone,
      updated_at timestamp without time zone
    );
    """
  end

  def down do
    """
    DROP TABLE stations;
    """
  end
end
