defmodule Lily.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias Lily.Repo

  alias Lily.Settings.Setting

  def get_settings() do
    from(s in Setting, limit: 1)
    |> Repo.one()
    |> case do
      nil ->
        %Setting{}
        |> Setting.changeset(%{})
        |> Repo.insert!()

      settings ->
        settings
    end
  end

  def allow_registration do
    get_settings().allow_registration
  end

  def allow_registration(true) do 
    update_settings(%{allow_registration: true}).allow_registration
  end

  def allow_registration(false) do 
    update_settings(%{allow_registration: false}).allow_registration
  end

  def allow_registration! do 
    current_status = allow_registration()
    update_settings(%{allow_registration: !current_status}).allow_registration
  end

  def update_settings(attrs) do 
    get_settings()
    |> Setting.changeset(attrs)
    |> Repo.update!()
  end
end
