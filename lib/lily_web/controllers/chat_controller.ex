defmodule LilyWeb.ChatController do
  use LilyWeb, :controller

  alias Lily.Chats
  alias Lily.Accounts

  action_fallback LilyWeb.FallbackController

  def create(%{assigns: %{current_user: user}} = conn, %{"friend" => friend_username}) do
    friend = Accounts.get_user_by!(username: friend_username)
    case Chats.create_chat(user, friend) do 
      {:ok, chat} ->
        conn
        |> render("create.json", chat_id: chat.id)

      {:error, reason} ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", reason: reason)
    end
  end
end
