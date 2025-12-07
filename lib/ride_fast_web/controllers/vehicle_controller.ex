defmodule RideFastWeb.VehicleController do
  use RideFastWeb, :controller

  alias RideFast.Vehicles
  alias RideFast.Vehicles.Vehicle

  action_fallback RideFastWeb.FallbackController

  def index(conn, %{"driver_id" => driver_id}) do
    vehicles = Vehicles.list_driver_vehicles(driver_id)
    render(conn, :index, vehicles: vehicles)
  end

  def create(conn, %{"driver_id" => driver_id, "vehicle" => vehicle_params}) do
    vehicle_params = Map.put(vehicle_params, "driver_id", driver_id)

    with {:ok, %Vehicle{} = vehicle} <- Vehicles.create_vehicle(vehicle_params) do
      conn
      |> put_status(:created)
      |> render(:show, vehicle: vehicle)
    end
  end

  def update(conn, %{"id" => id, "vehicle" => vehicle_params}) do
    vehicle = Vehicles.get_vehicle!(id)

    with {:ok, %Vehicle{} = vehicle} <- Vehicles.update_vehicle(vehicle, vehicle_params) do
      render(conn, :show, vehicle: vehicle)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle = Vehicles.get_vehicle!(id)

    with {:ok, %Vehicle{}} <- Vehicles.delete_vehicle(vehicle) do
      send_resp(conn, :no_content, "")
    end
  end
end
