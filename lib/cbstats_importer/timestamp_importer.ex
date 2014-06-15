defmodule CbstatsImporter.TimestampImporter do
  def import_timestamp(timestamp_datetime) do
    unless CbstatsImporter.TimestampQuery.timestamp_exists?(timestamp_datetime) do
      new_timestamp = %CbstatsImporter.Timestamp{
        taken_at: timestamp_datetime,
        created_at: CbstatsImporter.Util.now_datetime,
        updated_at: CbstatsImporter.Util.now_datetime
      }
      CbstatsImporter.Repo.insert(new_timestamp)
    end
  end
end
