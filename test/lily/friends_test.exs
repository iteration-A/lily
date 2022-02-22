defmodule Lily.FriendsTest do
  use Lily.DataCase, async: true

  alias Lily.Friends

  import Lily.FriendsFixtures
  import Lily.AccountsFixtures

  describe "list_friendships/0" do
    test "returns all friendships" do
      %{id: user_id} = user = user_fixture()
      %{id: friend_id} = friend = user_fixture()
      friendship_fixture(user, friend)

      assert [%{user_id: ^user_id, friend_id: ^friend_id}] = Friends.list_friendships()

      %{id: another_user_id} = another_user = user_fixture()
      %{id: another_friend_id} = another_friend = user_fixture()
      friendship_fixture(another_user, another_friend)

      assert [
               %{
                 user_id: ^user_id,
                 friend_id: ^friend_id
               },
               %{user_id: ^another_user_id, friend_id: ^another_friend_id}
             ] = Friends.list_friendships()
    end
  end

  describe "get_user_friendships/1" do
    test "returns all user friends" do
      current_user = user_fixture()
      friend1 = user_fixture()
      friend2 = user_fixture()
      friend3 = user_fixture()
      friends = [friend1, friend2, friend3]

      # create relationship
      for f <- friends do
        friendship_fixture(current_user, f)
      end

      # there has to be a better way to do this...
      # i need to remove passwords because `friends` *has*
      # the actual password, but `get_user_friendships`
      # will return a list with only the hashed_passwords
      # making both lists not match
      friends_without_password =
        friends
        |> Enum.map(fn user -> Map.put(user, :password, nil) end)

      returned_friends_without_password =
        Friends.get_user_friendships(current_user)
        |> Enum.map(fn user -> Map.put(user, :password, nil) end)

      for f <- friends_without_password do 
        assert f in returned_friends_without_password
      end
    end

    test "correctly handles cases when user is `friend_id` in the relationship" do
      %{id: current_user_id} = current_user = user_fixture()
      %{id: friend_id} = friend = user_fixture()

      # create friendship
      assert %{user_id: ^friend_id, friend_id: ^current_user_id} = friendship_fixture(friend, current_user)
      assert [%{id: ^friend_id}] = Friends.get_user_friendships(current_user)
    end

    test "correctly handles cases when user is `user_id` in the relationship" do
      %{id: current_user_id} = current_user = user_fixture()
      %{id: friend_id} = friend = user_fixture()

      # create friendship
      assert %{user_id: ^current_user_id, friend_id: ^friend_id} = friendship_fixture(current_user, friend)
      assert [%{id: ^friend_id}] = Friends.get_user_friendships(current_user)
    end
  end

  describe "add_friends/2" do
    test "can add two friends" do
      shinobu = user_fixture(username: "shinobu")
      giyu = user_fixture(username: "giyu")

      friendship_fixture(shinobu, giyu)

      shinobu_without_password = Map.put(shinobu, :password, nil)
      assert shinobu_without_password in Friends.get_user_friendships(giyu)
    end

    test "a user cannot add itself" do
      user = user_fixture()
      assert {:error, changeset} = Friends.add_friends(user, user)
      assert "a user cannot befriend itself" in errors_on(changeset).difference
    end

    test "a user cannot add other user who is already his friend" do
      user = user_fixture()
      friend = user_fixture()

      assert {:ok, _friendship} = Friends.add_friends(user, friend)
      assert {:error, changeset} = Friends.add_friends(friend, user)
      assert "users are already friends" in errors_on(changeset).already_friends
    end
  end

  describe "delete_friendship/1" do
    test "can delete two friends" do
      shinobu = user_fixture(username: "shinobu")
      giyu = user_fixture(username: "giyu")

      friendship = friendship_fixture(shinobu, giyu)

      shinobu_without_password = Map.put(shinobu, :password, nil)
      assert shinobu_without_password in Friends.get_user_friendships(giyu)

      assert {:ok, _} = Friends.delete_friendship(friendship) # :(
      refute shinobu_without_password in Friends.get_user_friendships(giyu)
    end
  end
end
