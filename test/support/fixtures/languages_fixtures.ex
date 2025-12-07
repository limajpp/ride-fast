defmodule RideFast.LanguagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Languages` context.
  """

  @doc """
  Generate a language.
  """
  def language_fixture(attrs \\ %{}) do
    {:ok, language} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> RideFast.Languages.create_language()

    language
  end
end
