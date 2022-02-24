defmodule Lily.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :user1_id, references(:users, on_delete: :nothing), null: false
      add :user2_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:chats, [:user1_id])
    create index(:chats, [:user2_id])
  end
end
