defmodule RideFastWeb.AuthController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Accounts.{User, Driver}
  alias RideFast.Guardian

  action_fallback RideFastWeb.FallbackController

  def register(conn, %{"role" => "user"} = params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:user_created, user: user)
    end
  end

  def register(conn, %{"role" => "driver"} = params) do
    with {:ok, %Driver{} = driver} <- Accounts.create_driver(params) do
      conn
      |> put_status(:created)
      |> render(:driver_created, driver: driver)
    end
  end

  def register(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid or missing role. Must be 'user' or 'driver'."})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case authenticate_any(email, password) do
      {:ok, resource} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(resource)

        conn
        |> put_status(:ok)
        |> render(:login, token: token, resource: resource)

      {:error, _reason} ->
        {:error, :unauthorized}
    end
  end

  defp authenticate_any(email, password) do
    with {:error, _} <- Accounts.authenticate_user(email, password),
         {:error, _} <- Accounts.authenticate_driver(email, password) do
      {:error, :unauthorized}
    else
      {:ok, resource} -> {:ok, resource}
    end
  end
end
