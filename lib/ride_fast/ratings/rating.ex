defmodule RideFast.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :comment, :string
    field :score, :integer

    belongs_to :ride, RideFast.Rides.Ride
    belongs_to :from_user, RideFast.Accounts.User
    belongs_to :to_driver, RideFast.Accounts.Driver

    timestamps(type: :utc_datetime)
  end

  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:score, :comment, :ride_id, :from_user_id, :to_driver_id])
    |> validate_required([:score, :ride_id, :from_user_id, :to_driver_id])
    |> validate_inclusion(:score, 1..5, message: "must be between 1 and 5")
    |> unique_constraint([:ride_id, :from_user_id], message: "You have already rated this ride")
  end
end
