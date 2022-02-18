defmodule Lily.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :allow_registration, :boolean, default: true, null: false

      timestamps()
    end
  end
end
