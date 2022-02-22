defmodule Lily.FriendsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lily.Friends` context.
  """

  @doc """
  Generate a friendship.
  """
  def friendship_fixture(user, friend) do
    {:ok, friendship} = Lily.Friends.add_friends(user, friend)

    friendship
  end
end
