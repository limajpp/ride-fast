defmodule RideFast.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :name, :string
      add :email, :string, null: false
      add :phone, :string
      add :password_hash, :string
      add :status, :string, default: "offline", null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:drivers, [:email])
  end
end
