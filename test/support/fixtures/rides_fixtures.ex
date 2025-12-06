defmodule RideFast.RidesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Rides` context.
  """

  @doc """
  Generate a ride.
  """
  def ride_fixture(attrs \\ %{}) do
    {:ok, ride} =
      attrs
      |> Enum.into(%{
        dest_lat: 120.5,
        dest_lng: 120.5,
        ended_at: ~U[2025-12-05 19:28:00Z],
        final_price: "120.5",
        origin_lat: 120.5,
        origin_lng: 120.5,
        price_estimate: "120.5",
        started_at: ~U[2025-12-05 19:28:00Z],
        status: "some status"
      })
      |> RideFast.Rides.create_ride()

    ride
  end
end
