defmodule LilyWeb.MessageController do
  use LilyWeb, :controller

  alias Lily.Chats

  action_fallback LilyWeb.FallbackController

  def index(conn, %{"chat_id" => chat_id}) do
    {chat_id, _} = Integer.parse(chat_id)
    chat = Chats.get_chat!(chat_id)

    conn
    |> render("index.json", messages: Chats.get_messages_by_chat(chat))
  end
end
