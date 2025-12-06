defmodule RideFast.Repo.Migrations.CreateDriverProfiles do
  use Ecto.Migration

  def change do
    create table(:driver_profiles, primary_key: false) do
      add :license_number, :string, null: false
      add :license_expiry, :date, null: false
      add :background_check_ok, :boolean, default: false, null: false

      add :driver_id, references(:drivers, on_delete: :delete_all), primary_key: true

      timestamps(type: :utc_datetime)
    end

    create index(:driver_profiles, [:driver_id])
  end
end
