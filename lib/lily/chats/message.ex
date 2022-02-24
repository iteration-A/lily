defmodule Lily.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :from, :id
    field :to, :id
    field :chat_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :from, :to, :chat_id])
    |> validate_required([:body, :from, :to, :chat_id])
    |> foreign_key_constraint(:from)
    |> foreign_key_constraint(:to)
  end
end
