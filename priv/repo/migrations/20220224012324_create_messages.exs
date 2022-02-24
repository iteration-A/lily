defmodule Lily.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text, null: false
      add :from, references(:users, on_delete: :nothing), null: false
      add :to, references(:users, on_delete: :nothing), null: false
      add :chat_id, references(:chats, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:messages, [:from])
    create index(:messages, [:to])
    create index(:messages, [:chat_id])
  end
end
