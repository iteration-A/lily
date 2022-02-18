defmodule Lily.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lily.Accounts` context.
  """

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        password: "some password",
        last_name: "some last_name",
        username: unique_user_username()
      })
      |> Lily.Accounts.create_user()

    user
  end
end
