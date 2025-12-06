defmodule RideFastWeb.AuthJSON do
  alias RideFast.Accounts.{User, Driver}

  def user_created(%{user: user}) do
    %{data: %{id: user.id, name: user.name, email: user.email, role: "user"}}
  end

  def driver_created(%{driver: driver}) do
    %{
      data: %{
        id: driver.id,
        name: driver.name,
        email: driver.email,
        role: "driver",
        status: driver.status
      }
    }
  end

  def login(%{token: token, resource: %User{} = user}) do
    %{token: token, user: %{id: user.id, name: user.name, role: "user"}}
  end

  def login(%{token: token, resource: %Driver{} = driver}) do
    %{token: token, user: %{id: driver.id, name: driver.name, role: "driver"}}
  end
end
