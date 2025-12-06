defmodule RideFast.DriversTest do
  use RideFast.DataCase

  alias RideFast.Drivers

  describe "driver_profiles" do
    alias RideFast.Drivers.DriverProfile

    import RideFast.DriversFixtures

    @invalid_attrs %{license_number: nil, license_expiry: nil, background_check_ok: nil}

    test "list_driver_profiles/0 returns all driver_profiles" do
      driver_profile = driver_profile_fixture()
      assert Drivers.list_driver_profiles() == [driver_profile]
    end

    test "get_driver_profile!/1 returns the driver_profile with given id" do
      driver_profile = driver_profile_fixture()
      assert Drivers.get_driver_profile!(driver_profile.id) == driver_profile
    end

    test "create_driver_profile/1 with valid data creates a driver_profile" do
      valid_attrs = %{license_number: "some license_number", license_expiry: ~D[2025-12-05], background_check_ok: true}

      assert {:ok, %DriverProfile{} = driver_profile} = Drivers.create_driver_profile(valid_attrs)
      assert driver_profile.license_number == "some license_number"
      assert driver_profile.license_expiry == ~D[2025-12-05]
      assert driver_profile.background_check_ok == true
    end

    test "create_driver_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drivers.create_driver_profile(@invalid_attrs)
    end

    test "update_driver_profile/2 with valid data updates the driver_profile" do
      driver_profile = driver_profile_fixture()
      update_attrs = %{license_number: "some updated license_number", license_expiry: ~D[2025-12-06], background_check_ok: false}

      assert {:ok, %DriverProfile{} = driver_profile} = Drivers.update_driver_profile(driver_profile, update_attrs)
      assert driver_profile.license_number == "some updated license_number"
      assert driver_profile.license_expiry == ~D[2025-12-06]
      assert driver_profile.background_check_ok == false
    end

    test "update_driver_profile/2 with invalid data returns error changeset" do
      driver_profile = driver_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Drivers.update_driver_profile(driver_profile, @invalid_attrs)
      assert driver_profile == Drivers.get_driver_profile!(driver_profile.id)
    end

    test "delete_driver_profile/1 deletes the driver_profile" do
      driver_profile = driver_profile_fixture()
      assert {:ok, %DriverProfile{}} = Drivers.delete_driver_profile(driver_profile)
      assert_raise Ecto.NoResultsError, fn -> Drivers.get_driver_profile!(driver_profile.id) end
    end

    test "change_driver_profile/1 returns a driver_profile changeset" do
      driver_profile = driver_profile_fixture()
      assert %Ecto.Changeset{} = Drivers.change_driver_profile(driver_profile)
    end
  end
end
