defmodule LilyWeb.FriendsController do
  use LilyWeb, :controller

  alias Lily.Friends
  alias Lily.Accounts

  action_fallback LilyWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    friends = Friends.get_user_friendships(user)

    conn
    |> render("index.json", friends: friends)
  end

  def create(conn, %{"friend" => friend_username}) do
    user = conn.assigns.current_user
    friend = Accounts.get_user_by!(username: friend_username)

    with {:ok, _friendship} <- Friends.add_friends(user, friend) do
      conn
      |> send_resp(:created, "")
    end
  end

  def delete(conn, %{"id" => friend_id}) do
    user = conn.assigns.current_user
    friend = Accounts.get_user!(friend_id)
    friendship = Friends.get_friendship!(user, friend)

    with {:ok, _lost_friendship} <- Friends.delete_friendship(friendship) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
