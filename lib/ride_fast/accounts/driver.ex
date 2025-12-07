defmodule RideFast.Accounts.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :status, Ecto.Enum, values: [:online, :offline, :busy], default: :offline

    has_many :vehicles, RideFast.Vehicles.Vehicle
    has_one :profile, RideFast.Drivers.DriverProfile

    many_to_many :languages, RideFast.Languages.Language,
      join_through: "drivers_languages",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password, :status])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def registration_changeset(driver, attrs) do
    driver
    |> changeset(attrs)
    |> validate_required([:password])
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
