defmodule RideFast.DriversFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Drivers` context.
  """

  @doc """
  Generate a driver_profile.
  """
  def driver_profile_fixture(attrs \\ %{}) do
    {:ok, driver_profile} =
      attrs
      |> Enum.into(%{
        background_check_ok: true,
        license_expiry: ~D[2025-12-05],
        license_number: "some license_number"
      })
      |> RideFast.Drivers.create_driver_profile()

    driver_profile
  end
end
