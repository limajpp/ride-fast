defmodule RideFastWeb.RatingController do
  use RideFastWeb, :controller

  alias RideFast.Ratings
  alias RideFast.Ratings.Rating
  alias RideFast.Rides
  alias RideFast.Guardian

  action_fallback RideFastWeb.FallbackController

  def index(conn, _params) do
    ratings = Ratings.list_ratings()
    render(conn, :index, ratings: ratings)
  end

  def create(conn, %{"ride_id" => ride_id} = params) do
    current_user = Guardian.Plug.current_resource(conn)
    ride = Rides.get_ride!(ride_id)

    rating_params =
      Map.merge(params, %{
        "ride_id" => ride.id,
        "from_user_id" => current_user.id,
        "to_driver_id" => ride.driver_id
      })

    if ride.user_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Only the passenger of this ride can rate it"})
    else
      case Ratings.create_rating(rating_params) do
        {:ok, %Rating{} = rating} ->
          conn
          |> put_status(:created)
          |> render(:show, rating: rating)

        {:error, :ride_not_finished} ->
          conn
          |> put_status(:conflict)
          |> json(%{error: "You can only rate finished rides"})

        {:error, changeset} ->
          {:error, changeset}
      end
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Ratings.get_rating!(id)
    render(conn, :show, rating: rating)
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Ratings.get_rating!(id)

    with {:ok, %Rating{} = rating} <- Ratings.update_rating(rating, rating_params) do
      render(conn, :show, rating: rating)
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Ratings.get_rating!(id)

    with {:ok, %Rating{}} <- Ratings.delete_rating(rating) do
      send_resp(conn, :no_content, "")
    end
  end

  def index_driver(conn, %{"driver_id" => driver_id}) do
    ratings = Ratings.list_driver_ratings(driver_id)
    render(conn, :index, ratings: ratings)
  end

  def index_ride(conn, %{"ride_id" => ride_id}) do
    ratings = Ratings.list_ride_ratings(ride_id)
    render(conn, :index, ratings: ratings)
  end
end
