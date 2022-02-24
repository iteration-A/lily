defmodule Lily.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Lily.Repo

  alias Lily.Chats.Chat
  alias Lily.Chats.Message
  alias Lily.Friends

  @doc """
  Returns a Chat record by id
  """
  def get_chat!(chat_id), do: Repo.get!(Chat, chat_id)

  @doc """
  Returns a Chat record

  ## Examples

      iex> get_chat(user, another_user)
      %Chat{}

      iex> get_chat(user, enemy)
      nil

  """
  def get_chat(%{id: user_id}, %{id: another_user_id}) do
    first_try =
      from(chat in Chat, where: chat.user1_id == ^user_id and chat.user2_id == ^another_user_id)
      |> Repo.one()

    if first_try do
      first_try
    else
      from(chat in Chat, where: chat.user1_id == ^another_user_id and chat.user2_id == ^user_id)
      |> Repo.one()
    end
  end

  @doc """
  Creates a Chat if one does not exists yet,
  otherwise returns the existing one.

  Returns `{:error, :not_friends}` if users are not friends.

  ## Examples

      iex> create_chat(user, another_user)
      %Chat{}

      iex> create_chat(user, unknown)
      {:error, :not_friends}

  """
  def create_chat(user, another_user) do
    with true <- Friends.are_friends?(user, another_user),
         chat when not is_nil(chat) <- get_chat(user, another_user) do
      {:ok, chat}
    else
      # they are not friends
      false ->
        {:error, :not_friends}

      # chat does not exists, but they are friends
      nil ->
        {:ok, chat} =
          %Chat{}
          |> Chat.changeset(%{user1_id: user.id, user2_id: another_user.id})
          |> Repo.insert()

        {:ok, chat}
    end
  end

  @doc """
  Adds a Message to a Chat.
  Returns Message.

  Returns `{:error, :chat_not_exists}` when there is no chat between the users.

  ## Examples

      iex> add_message(user, friend, message)
      %Message{}

      iex> add_message(user, unknown, message)
      {:error, :chat_not_exists}

  """
  def add_message(%{id: sender_id} = sender, %{id: receiver_id} = receiver, message) do
    with chat when not is_nil(chat) <- get_chat(sender, receiver) do
      attrs = Map.merge(message, %{chat_id: chat.id, from: sender_id, to: receiver_id})

      message =
        %Message{}
        |> Message.changeset(attrs)
        |> Repo.insert()

      with {:ok, message} <- message do
        message
      end
    else
      _ -> {:error, :chat_not_exists}
    end
  end

  @doc """
  Returns Messages from a Chat.

  Returns `{:error, :chat_not_exists}` when there is no chat between the users.

  ## Examples

      iex> get_messages(user, friend)
      %Message{}

      iex> get_messages(user, unknown)
      {:error, :chat_not_exists}

  """
  def get_messages(user, another_user) do
    case get_chat(user, another_user) do
      nil ->
        {:error, :chat_not_exists}

      chat ->
        from(m in Message, where: m.chat_id == ^chat.id)
        |> Repo.all()
    end
  end

  @doc """
  Is member? Self explanatory idk.
  Accepts either a %User{} or its id.

  ## Examples

      iex> is_member?(user, user)
      true

      iex> is_member?(user, none)
      false

  """
  def is_member?(chat, user) when is_map(user) do 
    chat.user1_id == user.id or chat.user2_id == user.id
  end

  def is_member?(chat, user_id) do
    chat.user1_id == user_id or chat.user2_id == user_id
  end
end
