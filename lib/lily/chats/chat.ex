defmodule Lily.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do

    field :user1_id, :id
    field :user2_id, :id

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:user1_id, :user2_id])
    |> validate_required([:user1_id, :user2_id])
    |> foreign_key_constraint(:user1_id)
    |> foreign_key_constraint(:user2_id)
  end
end
