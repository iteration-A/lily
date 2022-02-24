defmodule Lily.Friends do
  @moduledoc """
  The Friends context.
  """

  import Ecto.Query, warn: false
  alias Lily.Repo

  alias Lily.Friends.Friendship
  alias Lily.Accounts

  @doc """
  Returns the list of friendships.

  ## Examples

      iex> list_friendships()
      [%Friendship{}, ...]

  """
  def list_friendships do
    Repo.all(Friendship)
  end

  @doc """
  Returns a specific friendship.

  Raises `Ecto.NoResultsError` if no friendship exists.

  ## Examples

      iex> get_friendship!(user, friend)
      %Friendship{}

  """
  def get_friendship!(user, friend) do
    from(f in Friendship,
      where: f.user_id in [^user.id, ^friend.id] and f.friend_id in [^user.id, ^friend.id]
    )
    |> Repo.one!()
  end

  @doc """
  Returns a specific friendship.

  Returns nil if no friendship exists.

  ## Examples

      iex> get_friendship!(user, friend)
      %Friendship{}

  """
  def get_friendship(user, friend) do
    from(f in Friendship,
      where: f.user_id in [^user.id, ^friend.id] and f.friend_id in [^user.id, ^friend.id]
    )
    |> Repo.one()
  end

  @doc """
  Answers if two users are friends

  ## Examples

      iex> are_friends?(shinobu, kanao)
      true

      iex> are_friends?(shinobu, douma)
      false

  """
  def are_friends?(nil, nil), do: false
  def are_friends?(_, nil), do: false
  def are_friends?(nil, _), do: false

  def are_friends?(user, another_user) do 
    case get_friendship(user, another_user) do 
      %Friendship{} -> true
      _ -> false
    end
  end

  @doc """
  Gets logged in user friendships

  Returns `[]` if the Friendship does not exist.

  ## Examples

      iex> get_user_friendships(123)
      [%Friendship{...}, ...]

      iex> get_user_friendships(456)
      []

  """
  def get_user_friendships(%Accounts.User{id: id}) do
    from(f in Friendship,
      where: f.user_id == ^id or f.friend_id == ^id,
      join: friend in Accounts.User,
      on: f.friend_id == friend.id,
      join: user in Accounts.User,
      on: f.user_id == user.id,
      select: {user, friend}
    )
    |> Repo.all()
    |> Enum.map(fn {user, friend} ->
      if user.id == id do
        friend
      else
        user
      end
    end)
  end

  @doc """
  Creates a friendship.

  ## Examples

      iex> add_friends(%Accounts.User{...}, %Accounts.User{...})
      {:ok, %Friendship{}}

  """
  def add_friends(user, friend) do
    %Friendship{}
    |> Friendship.changeset(%{user_id: user.id, friend_id: friend.id})
    |> Repo.insert()
  end

  @doc """
  Deletes a friendship.

  ## Examples

      iex> delete_friendship(friendship)
      {:ok, %Friendship{}}

      iex> delete_friendship(friendship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_friendship(%Friendship{} = friendship) do
    Repo.delete(friendship)
  end
end
