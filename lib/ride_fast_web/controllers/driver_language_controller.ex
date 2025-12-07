defmodule RideFastWeb.DriverLanguageController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Languages

  action_fallback RideFastWeb.FallbackController

  def create(conn, %{"driver_id" => driver_id, "language_id" => lang_id}) do
    driver = Accounts.get_driver!(driver_id)
    language = Languages.get_language!(lang_id)

    with {:ok, _driver} <- Accounts.add_language_to_driver(driver, language) do
      conn
      |> put_status(:created)
      |> json(%{message: "Idioma adicionado com sucesso!"})
    end
  end

  def delete(conn, %{"driver_id" => driver_id, "language_id" => lang_id}) do
    driver = Accounts.get_driver!(driver_id)
    language = Languages.get_language!(lang_id)

    with {:ok, _driver} <- Accounts.remove_language_from_driver(driver, language) do
      send_resp(conn, :no_content, "")
    end
  end

  def index(conn, %{"driver_id" => driver_id}) do
    driver = Accounts.get_driver_with_languages!(driver_id)
    render(conn, :index, languages: driver.languages)
  end
end
