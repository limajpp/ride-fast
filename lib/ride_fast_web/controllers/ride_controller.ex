defmodule RideFastWeb.RideController do
  use RideFastWeb, :controller

  alias RideFast.Rides
  alias RideFast.Rides.Ride
  alias RideFast.Guardian
  alias RideFast.Accounts.Driver

  action_fallback RideFastWeb.FallbackController

  def create(conn, %{"ride" => ride_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    ride_params = Map.put(ride_params, "user_id", current_user.id)

    case Rides.create_ride(ride_params) do
      {:ok, %Ride{} = ride} ->
        conn
        |> put_status(:created)
        |> render(:show, ride: ride)

      {:error, :user_has_active_ride} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "You already have an active ride request"})

      {:error, changeset} ->
        {:error, changeset}
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

  def accept(conn, %{"id" => id, "vehicle_id" => vehicle_id}) do
    driver = Guardian.Plug.current_resource(conn)
    ride = Rides.get_ride!(id)

    case driver do
      %Driver{} ->
        handle_accept(conn, ride, driver, vehicle_id)

      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Only drivers can accept rides"})
    end
  end

  defp handle_accept(conn, ride, driver, vehicle_id) do
    case Rides.accept_ride(ride, driver, vehicle_id) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :ride_not_available} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Ride is not available or already accepted"})

      {:error, :driver_is_busy} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "You already have an active ride. Finish it first."})

      {:error, :invalid_vehicle} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Vehicle is invalid, inactive, or does not belong to you"})

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def start(conn, %{"id" => id}) do
    driver = Guardian.Plug.current_resource(conn)
    ride = Rides.get_ride!(id)

    case Rides.start_ride(ride, driver) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :ride_not_ready_to_start} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Ride cannot be started (must be ACCEPTED)"})

      {:error, :unauthorized_driver} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "You are not the driver for this ride"})
    end
  end

  def complete(conn, %{"id" => id, "final_price" => final_price}) do
    driver = Guardian.Plug.current_resource(conn)
    ride = Rides.get_ride!(id)

    case Rides.complete_ride(ride, driver, final_price) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :ride_not_in_progress} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Ride cannot be completed (must be IN_PROGRESS)"})

      {:error, :unauthorized_driver} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "You are not the driver for this ride"})
    end
  end
end
