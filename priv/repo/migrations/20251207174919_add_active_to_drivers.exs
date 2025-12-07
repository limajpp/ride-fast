defmodule RideFast.Repo.Migrations.AddActiveToDrivers do
  use Ecto.Migration

  def change do
    alter table(:drivers) do
      add :active, :boolean, default: true, null: false
    end
  end
end
