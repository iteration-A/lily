defmodule Lily.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lily.Settings` context.
  """

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        allow_registration: true
      })
      |> Lily.Settings.create_setting()

    setting
  end
end
