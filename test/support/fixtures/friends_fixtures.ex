defmodule Lily.FriendsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lily.Friends` context.
  """

  @doc """
  Generate a friendship.
  """
  def friendship_fixture(attrs \\ %{}) do
    {:ok, friendship} =
      attrs
      |> Enum.into(%{

      })
      |> Lily.Friends.create_friendship()

    friendship
  end
end
