defmodule RideFast.Drivers.DriverProfile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:driver_id, :id, autogenerate: false}

  schema "driver_profiles" do
    field :license_number, :string
    field :license_expiry, :date
    field :background_check_ok, :boolean, default: false

    belongs_to :driver, RideFast.Accounts.Driver, define_field: false

    timestamps(type: :utc_datetime)
  end

  def changeset(driver_profile, attrs) do
    driver_profile
    |> cast(attrs, [:license_number, :license_expiry, :background_check_ok, :driver_id])
    |> validate_required([:license_number, :license_expiry, :driver_id])
    |> validate_future_date(:license_expiry)
  end

  defp validate_future_date(changeset, field) do
    validate_change(changeset, field, fn _, date ->
      if Date.compare(date, Date.utc_today()) == :gt do
        []
      else
        [{field, "CNH expired or invalid date"}]
      end
    end)
  end
end
