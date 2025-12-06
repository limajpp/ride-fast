defmodule RideFast.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :plate, :string, null: false
      add :model, :string, null: false
      add :color, :string
      add :seats, :integer, default: 4
      add :active, :boolean, default: true, null: false
      add :driver_id, references(:drivers, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:vehicles, [:driver_id])
    create unique_index(:vehicles, [:plate])
  end
end
