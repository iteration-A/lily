defmodule Lily.AccountsTest do
  use Lily.DataCase

  alias Lily.Accounts

  describe "users" do
    alias Lily.Accounts.User

    import Lily.AccountsFixtures

    @invalid_attrs %{first_name: nil, hashed_password: nil, last_name: nil, username: nil}
    @valid_attrs %{
      username: "mari",
      first_name: "mari",
      password: "mari is cool",
      last_name: "last_name"
    }

    test "list_users/0 returns all users" do
      %{id: id} = user_fixture()
      assert [%{id: ^id}] = Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      %{id: id, username: username} = user_fixture()
      assert %{id: ^id, username: ^username} = Accounts.get_user!(id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == @valid_attrs.first_name
      assert user.last_name == @valid_attrs.last_name
      assert String.starts_with?(user.username, @valid_attrs.username)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        first_name: "some updated first_name",
        password: "some updated password",
        last_name: "some updated last_name",
        username: "random_user"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.first_name == update_attrs.first_name
      assert user.last_name == update_attrs.last_name
      assert user.username == update_attrs.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      new_first_name = "Cool first name"

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, %{@invalid_attrs | first_name: new_first_name})

      assert user.first_name != new_first_name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
