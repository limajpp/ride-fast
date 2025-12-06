defmodule RideFast.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :active, :boolean, default: true
    field :color, :string
    field :model, :string
    field :plate, :string
    field :seats, :integer

    belongs_to :driver, RideFast.Accounts.Driver

    timestamps(type: :utc_datetime)
  end

  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate, :model, :color, :seats, :active, :driver_id])
    |> validate_required([:plate, :model, :seats, :driver_id])
    |> validate_length(:plate, min: 7, max: 8)
    |> unique_constraint(:plate)
  end
end
