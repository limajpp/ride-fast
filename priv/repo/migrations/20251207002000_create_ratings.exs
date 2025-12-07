defmodule RideFast.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :score, :integer, null: false
      add :comment, :text

      add :ride_id, references(:rides, on_delete: :nothing), null: false
      add :from_user_id, references(:users, on_delete: :nothing), null: false
      add :to_driver_id, references(:drivers, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:ratings, [:ride_id])
    create index(:ratings, [:from_user_id])
    create index(:ratings, [:to_driver_id])

    create constraint(:ratings, :score_must_be_between_1_and_5,
             check: "score >= 1 AND score <= 5"
           )
  end
end
