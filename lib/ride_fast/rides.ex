defmodule RideFast.Rides do
  @moduledoc """
  The Rides context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Rides.Ride

  alias RideFast.Accounts.Driver

  alias RideFast.Vehicles
  alias RideFast.Vehicles.Vehicle

  alias RideFast.Accounts.User

  @doc """
  Returns the list of rides.

  ## Examples

      iex> list_rides()
      [%Ride{}, ...]

  """
  def list_rides do
    Repo.all(Ride)
  end

  @doc """
  Gets a single ride.

  Raises `Ecto.NoResultsError` if the Ride does not exist.

  ## Examples

      iex> get_ride!(123)
      %Ride{}

      iex> get_ride!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ride!(id), do: Repo.get!(Ride, id)

  @doc """
  Creates a ride.

  ## Examples

      iex> create_ride(%{field: value})
      {:ok, %Ride{}}

      iex> create_ride(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ride(attrs) do
    user_id = attrs["user_id"] || attrs[:user_id]

    if user_has_active_ride?(user_id) do
      {:error, :user_has_active_ride}
    else
      %Ride{}
      |> Ride.changeset(attrs)
      |> Repo.insert()
    end
  end

  defp user_has_active_ride?(user_id) do
    query =
      from r in Ride,
        where: r.user_id == ^user_id and r.status in [:solicitada, :aceita, :em_andamento]

    Repo.exists?(query)
  end

  @doc """
  Updates a ride.

  ## Examples

      iex> update_ride(ride, %{field: new_value})
      {:ok, %Ride{}}

      iex> update_ride(ride, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ride(%Ride{} = ride, attrs) do
    ride
    |> Ride.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ride.

  ## Examples

      iex> delete_ride(ride)
      {:ok, %Ride{}}

      iex> delete_ride(ride)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ride(%Ride{} = ride) do
    Repo.delete(ride)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ride changes.

  ## Examples

      iex> change_ride(ride)
      %Ecto.Changeset{data: %Ride{}}

  """
  def change_ride(%Ride{} = ride, attrs \\ %{}) do
    Ride.changeset(ride, attrs)
  end

  @doc """
  Transição de estado: SOLICITADA -> ACEITA.
  """
  def accept_ride(%Ride{status: :solicitada} = ride, %Driver{} = driver, vehicle_id) do
    if driver_has_active_ride?(driver.id) do
      {:error, :driver_is_busy}
    else
      case Vehicles.get_driver_active_vehicle(driver.id, vehicle_id) do
        %Vehicle{} ->
          ride
          |> Ride.changeset(%{
            status: :aceita,
            driver_id: driver.id,
            vehicle_id: vehicle_id
          })
          |> Repo.update()

        nil ->
          {:error, :invalid_vehicle}
      end
    end
  end

  defp driver_has_active_ride?(driver_id) do
    query =
      from r in Ride,
        where: r.driver_id == ^driver_id and r.status in [:aceita, :em_andamento]

    Repo.exists?(query)
  end

  def accept_ride(%Ride{}, _driver, _vehicle_id) do
    {:error, :ride_not_available}
  end

  @doc """
  Transição: ACEITA -> EM_ANDAMENTO
  Valida se quem está tentando iniciar é o motorista definido na corrida.
  """
  def start_ride(%Ride{status: :aceita} = ride, %Driver{} = driver) do
    if ride.driver_id == driver.id do
      ride
      |> Ride.changeset(%{
        status: :em_andamento,
        started_at: DateTime.utc_now()
      })
      |> Repo.update()
    else
      {:error, :unauthorized_driver}
    end
  end

  def start_ride(%Ride{}, _driver), do: {:error, :ride_not_ready_to_start}

  @doc """
  Transição: EM_ANDAMENTO -> FINALIZADA
  Recebe o preço final e conclui a corrida.
  """
  def complete_ride(%Ride{status: :em_andamento} = ride, %Driver{} = driver, final_price) do
    if ride.driver_id == driver.id do
      ride
      |> Ride.changeset(%{
        status: :finalizada,
        ended_at: DateTime.utc_now(),
        final_price: final_price
      })
      |> Repo.update()
    else
      {:error, :unauthorized_driver}
    end
  end

  def complete_ride(%Ride{}, _driver, _final_price), do: {:error, :ride_not_in_progress}

  @doc """
  Cancela uma corrida.
  Pode ser chamada pelo Passageiro (User) ou Motorista (Driver).
  """
  def cancel_ride(%Ride{status: status} = ride, actor) when status in [:solicitada, :aceita] do
    is_owner =
      case actor do
        %User{id: id} -> ride.user_id == id
        %Driver{id: id} -> ride.driver_id == id
        _ -> false
      end

    if is_owner do
      ride
      |> Ride.changeset(%{status: :cancelada, ended_at: DateTime.utc_now()})
      |> Repo.update()
    else
      {:error, :unauthorized_action}
    end
  end

  def cancel_ride(%Ride{}, _actor), do: {:error, :cannot_cancel_at_this_stage}
end
