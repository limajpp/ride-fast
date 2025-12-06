defmodule RideFast.Rides.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    field :status, Ecto.Enum,
      values: [:solicitada, :aceita, :em_andamento, :finalizada, :cancelada],
      default: :solicitada

    field :origin_lat, :float
    field :origin_lng, :float
    field :dest_lat, :float
    field :dest_lng, :float

    field :price_estimate, :decimal
    field :final_price, :decimal

    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime

    belongs_to :user, RideFast.Accounts.User
    belongs_to :driver, RideFast.Accounts.Driver
    belongs_to :vehicle, RideFast.Vehicles.Vehicle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ride, attrs) do
    ride
    |> cast(attrs, [
      :origin_lat,
      :origin_lng,
      :dest_lat,
      :dest_lng,
      :price_estimate,
      :status,
      :user_id,
      :driver_id,
      :vehicle_id,
      :started_at,
      :ended_at,
      :final_price
    ])
    |> validate_required([
      :origin_lat,
      :origin_lng,
      :dest_lat,
      :dest_lng,
      :price_estimate,
      :user_id
    ])
    |> validate_number(:origin_lat, greater_than: -90, less_than: 90)
    |> validate_number(:origin_lng, greater_than: -180, less_than: 180)
  end
end
