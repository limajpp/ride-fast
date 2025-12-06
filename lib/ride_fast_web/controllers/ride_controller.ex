defmodule RideFastWeb.RideController do
  use RideFastWeb, :controller

  alias RideFast.Rides
  alias RideFast.Rides.Ride
  alias RideFast.Guardian

  action_fallback RideFastWeb.FallbackController

  def create(conn, %{"ride" => ride_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    ride_params = Map.put(ride_params, "user_id", current_user.id)

    with {:ok, %Ride{} = ride} <- Rides.create_ride(ride_params) do
      conn
      |> put_status(:created)
      |> render(:show, ride: ride)
    end
  end

  def index(conn, _params) do
    rides = Rides.list_rides()
    render(conn, :index, rides: rides)
  end

  def show(conn, %{"id" => id}) do
    ride = Rides.get_ride!(id)
    render(conn, :show, ride: ride)
  end
end
