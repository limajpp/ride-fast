defmodule RideFast.Drivers do
  @moduledoc """
  The Drivers context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Drivers.DriverProfile

  @doc """
  Returns the list of driver_profiles.

  ## Examples

      iex> list_driver_profiles()
      [%DriverProfile{}, ...]

  """
  def list_driver_profiles do
    Repo.all(DriverProfile)
  end

  @doc """
  Gets a single driver_profile.

  Raises `Ecto.NoResultsError` if the Driver profile does not exist.

  ## Examples

      iex> get_driver_profile!(123)
      %DriverProfile{}

      iex> get_driver_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_driver_profile!(id), do: Repo.get!(DriverProfile, id)

  @doc """
  Gets a single driver_profile.
  Returns nil if the Driver profile does not exist.
  """
  def get_driver_profile(driver_id), do: Repo.get(DriverProfile, driver_id)

  @doc """
  Creates a driver_profile.

  ## Examples

      iex> create_driver_profile(%{field: value})
      {:ok, %DriverProfile{}}

      iex> create_driver_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_driver_profile(attrs) do
    %DriverProfile{}
    |> DriverProfile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a driver_profile.

  ## Examples

      iex> update_driver_profile(driver_profile, %{field: new_value})
      {:ok, %DriverProfile{}}

      iex> update_driver_profile(driver_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_driver_profile(%DriverProfile{} = driver_profile, attrs) do
    driver_profile
    |> DriverProfile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a driver_profile.

  ## Examples

      iex> delete_driver_profile(driver_profile)
      {:ok, %DriverProfile{}}

      iex> delete_driver_profile(driver_profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_driver_profile(%DriverProfile{} = driver_profile) do
    Repo.delete(driver_profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking driver_profile changes.

  ## Examples

      iex> change_driver_profile(driver_profile)
      %Ecto.Changeset{data: %DriverProfile{}}

  """
  def change_driver_profile(%DriverProfile{} = driver_profile, attrs \\ %{}) do
    DriverProfile.changeset(driver_profile, attrs)
  end
end
