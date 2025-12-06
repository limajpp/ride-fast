defmodule RideFast.Vehicles do
  @moduledoc """
  The Vehicles context.
  """
  import Ecto.Query, warn: false
  alias RideFast.Repo
  alias RideFast.Vehicles.Vehicle

  def list_driver_vehicles(driver_id) do
    from(v in Vehicle, where: v.driver_id == ^driver_id and v.active == true)
    |> Repo.all()
  end

  def get_vehicle!(id), do: Repo.get!(Vehicle, id)

  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
  end

  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.changeset(attrs)
    |> Repo.update()
  end

  def delete_vehicle(%Vehicle{} = vehicle) do
    update_vehicle(vehicle, %{active: false})
  end
end
