defmodule LilyWeb.RoomChannel do
  use LilyWeb, :channel
  alias Lily.Chats

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    if authorized?(room_id, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("new_message", %{"message" => m}, socket) do
    user = socket.assigns.user_id
    broadcast!(socket, "new_message", %{message: m, from: user})
    {:noreply, socket}
  end

  defp authorized?(room_id, %{assigns: %{user_id: user_id}}) do
    chat = Chats.get_chat!(room_id)
    Chats.is_member?(chat, user_id)
  end
end
