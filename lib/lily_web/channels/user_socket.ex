defmodule LilyWeb.UserSocket do
  use Phoenix.Socket

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Uncomment the following line to define a "room:*" topic
  # pointing to the `LilyWeb.RoomChannel`:
  #
  channel "room:*", LilyWeb.RoomChannel
  #
  # To create a channel file, use the mix task:
  #
  #     mix phx.gen.channel Room
  #
  # See the [`Channels guide`](https://hexdocs.pm/phoenix/channels.html)
  # for further details.

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}

      _ ->
        :error
    end
  end

  @impl true
  def connect(_, _socket) do
    :error
  end

  @one_week 60 * 60 * 24 * 7
  defp verify(socket, token) do
    Phoenix.Token.verify(socket, "auth salt", token, max_age: @one_week)
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.LilyWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(%{assigns: %{user_id: user_id}}), do: "user:#{user_id}"
end
