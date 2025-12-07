defmodule RideFastWeb.DriverLanguageJSON do
  alias RideFast.Languages.Language

  def index(%{languages: languages}) do
    %{data: for(language <- languages, do: data(language))}
  end

  defp data(%Language{} = language) do
    %{
      id: language.id,
      code: language.code,
      name: language.name
    }
  end
end
