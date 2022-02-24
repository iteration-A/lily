defmodule Lily.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lily.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{})
      |> Lily.Chats.create_chat()

    chat
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Lily.Chats.create_message()

    message
  end
end
