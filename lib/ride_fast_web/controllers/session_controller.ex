defmodule RideFastWeb.SessionController do
  use RideFastWeb, :controller

  alias RideFast.Accounts
  alias RideFast.Guardian

  action_fallback RideFastWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render(:login, token: token, user: user)
    end
  end
end
