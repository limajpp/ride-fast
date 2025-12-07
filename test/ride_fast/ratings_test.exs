defmodule RideFast.RatingsTest do
  use RideFast.DataCase

  alias RideFast.Ratings

  describe "ratings" do
    alias RideFast.Ratings.Rating

    import RideFast.RatingsFixtures

    @invalid_attrs %{comment: nil, score: nil}

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Ratings.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Ratings.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      valid_attrs = %{comment: "some comment", score: 42}

      assert {:ok, %Rating{} = rating} = Ratings.create_rating(valid_attrs)
      assert rating.comment == "some comment"
      assert rating.score == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ratings.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      update_attrs = %{comment: "some updated comment", score: 43}

      assert {:ok, %Rating{} = rating} = Ratings.update_rating(rating, update_attrs)
      assert rating.comment == "some updated comment"
      assert rating.score == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Ratings.update_rating(rating, @invalid_attrs)
      assert rating == Ratings.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Ratings.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Ratings.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Ratings.change_rating(rating)
    end
  end
end
