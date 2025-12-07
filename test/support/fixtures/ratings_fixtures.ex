defmodule RideFast.RatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Ratings` context.
  """

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        score: 42
      })
      |> RideFast.Ratings.create_rating()

    rating
  end
end
