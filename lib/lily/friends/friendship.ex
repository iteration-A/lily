defmodule Lily.Friends.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Lily.Friends.Friendship
  alias Lily.Repo

  schema "friendships" do
    field :user_id, :id
    field :friend_id, :id

    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user_id, :friend_id])
    |> validate_required([:user_id, :friend_id])
    |> validate_difference()
    |> validate_not_friends()
  end

  defp validate_difference(
         %Ecto.Changeset{changes: %{user_id: user_id, friend_id: friend_id}} = changeset
       ) do
    if user_id == friend_id do
      add_error(changeset, :difference, "a user cannot befriend itself")
    else
      changeset
    end
  end

  defp validate_difference(%Ecto.Changeset{valid?: false} = changeset) do
    changeset
  end

  defp validate_not_friends(%{valid?: false} = changeset), do: changeset

  defp validate_not_friends(%{changes: %{user_id: user_id, friend_id: friend_id}} = changeset) do
    possible_friendships = [
      [user_id, friend_id],
      [friend_id, user_id]
    ]

    # I know this is ugly i'm sorry...
    # returns true if they are friends
    Enum.any?(possible_friendships, fn [user, friend] ->
      from(f in Friendship, where: f.user_id == ^user and f.friend_id == ^friend)
      |> Repo.one()
    end)
    |> if do 
      changeset
      |> add_error(:already_friends, "users are already friends")
    else
      changeset
    end
  end
end
