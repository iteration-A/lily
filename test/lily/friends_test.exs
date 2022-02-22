defmodule Lily.FriendsTest do
  use Lily.DataCase

  alias Lily.Friends

  describe "friendships" do
    alias Lily.Friends.Friendship

    import Lily.FriendsFixtures

    @invalid_attrs %{}

    test "list_friendships/0 returns all friendships" do
      friendship = friendship_fixture()
      assert Friends.list_friendships() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friends.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      valid_attrs = %{}

      assert {:ok, %Friendship{} = friendship} = Friends.create_friendship(valid_attrs)
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friends.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      update_attrs = %{}

      assert {:ok, %Friendship{} = friendship} = Friends.update_friendship(friendship, update_attrs)
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()
      assert {:error, %Ecto.Changeset{}} = Friends.update_friendship(friendship, @invalid_attrs)
      assert friendship == Friends.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friends.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friends.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friends.change_friendship(friendship)
    end
  end
end
