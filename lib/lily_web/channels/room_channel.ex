defmodule LilyWeb.RoomChannel do
  use LilyWeb, :channel
  alias Lily.Chats

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    if authorized?(room_id, socket) do
      socket = assign(socket, :room_id, room_id)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("new_message", %{"message" => m}, %{assigns: %{room_id: room_id}} = socket) do
    user_id = socket.assigns.user_id
    chat = Chats.get_chat!(room_id)

    user = %{id: user_id}
    other_user =
      if chat.user1_id == user_id do
        %{id: chat.user2_id}
      else
        %{id: chat.user1_id}
      end

    message = Chats.add_message(user, other_user, %{body: m})

    broadcast!(socket, "new_message", %{message: message})
    {:noreply, socket}
  end

  defp authorized?(room_id, %{assigns: %{user_id: user_id}}) do
    chat = Chats.get_chat!(room_id)
    Chats.is_member?(chat, user_id)
  end
end
