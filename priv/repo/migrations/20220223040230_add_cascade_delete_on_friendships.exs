defmodule Lily.Repo.Migrations.AddCascadeDeleteOnFriendships do
  use Ecto.Migration

  def up do
    drop(constraint(:friendships, "friendships_user_id_fkey"))
    drop(constraint(:friendships, "friendships_friend_id_fkey"))

    alter table(:friendships) do
      modify(:user_id, references(:users, on_delete: :delete_all), null: false)
      modify(:friend_id, references(:users, on_delete: :delete_all), null: false)
    end
  end

  def down do
    drop(constraint(:friendships, "friendships_user_id_fkey"))
    drop(constraint(:friendships, "friendships_friend_id_fkey"))
  end
end
