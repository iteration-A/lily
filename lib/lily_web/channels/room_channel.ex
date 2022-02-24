defmodule LilyWeb.RoomChannel do
  use LilyWeb, :channel
  alias Lily.Friends
  alias Lily.Accounts

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    if authorized?(room_id, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_message", %{"message" => m}, socket) do 
    user = socket.assigns.user_id
    broadcast!(socket, "new_message", %{message: m, from: user})
    {:noreply, socket}
  end

  defp authorized?(room_id, %{assigns: %{user_id: user_id}}) do
    user = Accounts.get_user(user_id)
    friend = Accounts.get_user_by(username: room_id)

    Friends.are_friends?(user, friend)
  end
end
