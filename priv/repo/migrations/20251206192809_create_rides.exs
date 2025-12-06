defmodule RideFast.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :origin_lat, :float, null: false
      add :origin_lng, :float, null: false
      add :dest_lat, :float, null: false
      add :dest_lng, :float, null: false
      add :status, :string, default: "SOLICITADA", null: false
      add :price_estimate, :decimal, precision: 10, scale: 2
      add :final_price, :decimal, precision: 10, scale: 2
      add :started_at, :utc_datetime
      add :ended_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :driver_id, references(:drivers, on_delete: :nothing), null: true
      add :vehicle_id, references(:vehicles, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:rides, [:user_id])
    create index(:rides, [:driver_id])
    create index(:rides, [:status])
  end
end
