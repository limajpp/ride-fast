defmodule RideFast.Ratings do
  @moduledoc """
  The Ratings context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Ratings.Rating

  alias RideFast.Rides

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings()
      [%Rating{}, ...]

  """
  def list_ratings do
    Repo.all(Rating)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(id), do: Repo.get!(Rating, id)

  def create_rating(attrs \\ %{}) do
    ride_id = attrs["ride_id"] || attrs[:ride_id]

    try do
      ride = Rides.get_ride!(ride_id)

      cond do
        ride.status != :finalizada ->
          {:error, :ride_not_finished}

        true ->
          %Rating{}
          |> Rating.changeset(attrs)
          |> Repo.insert()
      end
    rescue
      Ecto.NoResultsError -> {:error, :ride_not_found}
    end
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{data: %Rating{}}

  """
  def change_rating(%Rating{} = rating, attrs \\ %{}) do
    Rating.changeset(rating, attrs)
  end

  def list_driver_ratings(driver_id) do
    from(r in Rating, where: r.to_driver_id == ^driver_id)
    |> Repo.all()
  end

  def list_ride_ratings(ride_id) do
    from(r in Rating, where: r.ride_id == ^ride_id)
    |> Repo.all()
  end
end
