defmodule RideFast.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Accounts.User
  alias RideFast.Languages.Language

  def list_users do
    from(u in User, where: u.active == true)
    |> Repo.all()
  end

  def get_user!(id) do
    Repo.get_by!(User, id: id, active: true)
  end

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    update_user(user, %{active: false})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email, active: true)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  alias RideFast.Accounts.Driver

  @doc """
  Returns the list of drivers.

  ## Examples

      iex> list_drivers()
      [%Driver{}, ...]

  """
  def list_drivers do
    Repo.all(Driver)
  end

  @doc """
  Gets a single driver.

  Raises `Ecto.NoResultsError` if the Driver does not exist.

  ## Examples

      iex> get_driver!(123)
      %Driver{}

      iex> get_driver!(456)
      ** (Ecto.NoResultsError)

  """
  def get_driver!(id), do: Repo.get!(Driver, id)

  def create_driver(attrs) do
    %Driver{}
    |> Driver.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a driver.

  ## Examples

      iex> update_driver(driver, %{field: new_value})
      {:ok, %Driver{}}

      iex> update_driver(driver, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a driver.

  ## Examples

      iex> delete_driver(driver)
      {:ok, %Driver{}}

      iex> delete_driver(driver)
      {:error, %Ecto.Changeset{}}

  """
  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking driver changes.

  ## Examples

      iex> change_driver(driver)
      %Ecto.Changeset{data: %Driver{}}

  """
  def change_driver(%Driver{} = driver, attrs \\ %{}) do
    Driver.changeset(driver, attrs)
  end

  def authenticate_driver(email, password) do
    driver = Repo.get_by(Driver, email: email)

    cond do
      driver && Bcrypt.verify_pass(password, driver.password_hash) ->
        {:ok, driver}

      true ->
        {:error, :unauthorized}
    end
  end

  def get_driver_with_languages!(id) do
    Driver
    |> Repo.get!(id)
    |> Repo.preload(:languages)
  end

  def add_language_to_driver(%Driver{} = driver, %Language{} = language) do
    driver = Repo.preload(driver, :languages)

    new_languages = [language | driver.languages] |> Enum.uniq_by(& &1.id)

    driver
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:languages, new_languages)
    |> Repo.update()
  end

  def remove_language_from_driver(%Driver{} = driver, %Language{} = language) do
    driver = Repo.preload(driver, :languages)
    new_languages = Enum.reject(driver.languages, fn l -> l.id == language.id end)

    driver
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:languages, new_languages)
    |> Repo.update()
  end
end
