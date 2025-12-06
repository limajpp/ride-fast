defmodule RideFastWeb.DriverProfileController do
  use RideFastWeb, :controller

  alias RideFast.Drivers
  alias RideFast.Drivers.DriverProfile

  action_fallback RideFastWeb.FallbackController

  def show(conn, %{"driver_id" => driver_id}) do
    driver_profile = Drivers.get_driver_profile!(driver_id)
    render(conn, :show, driver_profile: driver_profile)
  end

  def create(conn, %{"driver_id" => driver_id} = params) do
    profile_params = Map.merge(params, %{"driver_id" => driver_id})

    with nil <- Drivers.get_driver_profile(driver_id),
         {:ok, %DriverProfile{} = driver_profile} <- Drivers.create_driver_profile(profile_params) do
      conn
      |> put_status(:created)
      |> render(:show, driver_profile: driver_profile)
    else
      %DriverProfile{} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Profile already exists for this driver"})

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update(conn, %{"driver_id" => driver_id} = params) do
    driver_profile = Drivers.get_driver_profile!(driver_id)

    with {:ok, %DriverProfile{} = driver_profile} <-
           Drivers.update_driver_profile(driver_profile, params) do
      render(conn, :show, driver_profile: driver_profile)
    end
  end
end
