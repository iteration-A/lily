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
  Gets a single friendship.

  Raises `Ecto.NoResultsError` if the Friendship does not exist.

  ## Examples

      iex> get_friendship!(123)
      %Friendship{}

      iex> get_friendship!(456)
      ** (Ecto.NoResultsError)

  """
  def get_friendship!(id), do: Repo.get!(Friendship, id)

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
      select: friend
    )
    |> Repo.all()
    |> Enum.filter(fn %{id: user_id} -> user_id != id end)
  end

  @doc """
  Creates a friendship.

  ## Examples

      iex> create_friendship(%{field: value})
      {:ok, %Friendship{}}

      iex> create_friendship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_friendship(attrs \\ %{}) do
    %Friendship{}
    |> Friendship.changeset(attrs)
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
