defmodule RideFast.Guardian do
  use Guardian, otp_app: :ride_fast

  alias RideFast.Accounts
  alias RideFast.Accounts.{User, Driver}

  def subject_for_token(%User{} = user, _claims) do
    {:ok, "User:#{user.id}"}
  end

  def subject_for_token(%Driver{} = driver, _claims) do
    {:ok, "Driver:#{driver.id}"}
  end

  def subject_for_token(_, _), do: {:error, :unknown_resource}

  def resource_from_claims(%{"sub" => "User:" <> id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(%{"sub" => "Driver:" <> id}) do
    case Accounts.get_driver!(id) do
      nil -> {:error, :resource_not_found}
      driver -> {:ok, driver}
    end
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_), do: {:error, :unknown_resource}
end
