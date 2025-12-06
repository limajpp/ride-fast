defmodule RideFast.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        active: true,
        color: "some color",
        model: "some model",
        plate: "some plate",
        seats: 42
      })
      |> RideFast.Vehicles.create_vehicle()

    vehicle
  end
end
