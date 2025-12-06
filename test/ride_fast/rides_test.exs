defmodule RideFast.RidesTest do
  use RideFast.DataCase

  alias RideFast.Rides

  describe "rides" do
    alias RideFast.Rides.Ride

    import RideFast.RidesFixtures

    @invalid_attrs %{status: nil, started_at: nil, origin_lat: nil, origin_lng: nil, dest_lat: nil, dest_lng: nil, price_estimate: nil, final_price: nil, ended_at: nil}

    test "list_rides/0 returns all rides" do
      ride = ride_fixture()
      assert Rides.list_rides() == [ride]
    end

    test "get_ride!/1 returns the ride with given id" do
      ride = ride_fixture()
      assert Rides.get_ride!(ride.id) == ride
    end

    test "create_ride/1 with valid data creates a ride" do
      valid_attrs = %{status: "some status", started_at: ~U[2025-12-05 19:28:00Z], origin_lat: 120.5, origin_lng: 120.5, dest_lat: 120.5, dest_lng: 120.5, price_estimate: "120.5", final_price: "120.5", ended_at: ~U[2025-12-05 19:28:00Z]}

      assert {:ok, %Ride{} = ride} = Rides.create_ride(valid_attrs)
      assert ride.status == "some status"
      assert ride.started_at == ~U[2025-12-05 19:28:00Z]
      assert ride.origin_lat == 120.5
      assert ride.origin_lng == 120.5
      assert ride.dest_lat == 120.5
      assert ride.dest_lng == 120.5
      assert ride.price_estimate == Decimal.new("120.5")
      assert ride.final_price == Decimal.new("120.5")
      assert ride.ended_at == ~U[2025-12-05 19:28:00Z]
    end

    test "create_ride/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rides.create_ride(@invalid_attrs)
    end

    test "update_ride/2 with valid data updates the ride" do
      ride = ride_fixture()
      update_attrs = %{status: "some updated status", started_at: ~U[2025-12-06 19:28:00Z], origin_lat: 456.7, origin_lng: 456.7, dest_lat: 456.7, dest_lng: 456.7, price_estimate: "456.7", final_price: "456.7", ended_at: ~U[2025-12-06 19:28:00Z]}

      assert {:ok, %Ride{} = ride} = Rides.update_ride(ride, update_attrs)
      assert ride.status == "some updated status"
      assert ride.started_at == ~U[2025-12-06 19:28:00Z]
      assert ride.origin_lat == 456.7
      assert ride.origin_lng == 456.7
      assert ride.dest_lat == 456.7
      assert ride.dest_lng == 456.7
      assert ride.price_estimate == Decimal.new("456.7")
      assert ride.final_price == Decimal.new("456.7")
      assert ride.ended_at == ~U[2025-12-06 19:28:00Z]
    end

    test "update_ride/2 with invalid data returns error changeset" do
      ride = ride_fixture()
      assert {:error, %Ecto.Changeset{}} = Rides.update_ride(ride, @invalid_attrs)
      assert ride == Rides.get_ride!(ride.id)
    end

    test "delete_ride/1 deletes the ride" do
      ride = ride_fixture()
      assert {:ok, %Ride{}} = Rides.delete_ride(ride)
      assert_raise Ecto.NoResultsError, fn -> Rides.get_ride!(ride.id) end
    end

    test "change_ride/1 returns a ride changeset" do
      ride = ride_fixture()
      assert %Ecto.Changeset{} = Rides.change_ride(ride)
    end
  end
end
