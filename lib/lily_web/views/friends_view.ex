defmodule LilyWeb.FriendsView do
  use LilyWeb, :view

  def render("index.json", %{friends: friends}) do
    IO.inspect(friends)
    %{data: render("friends", friends: friends)}
  end

  def render("friends", %{friends: friends}) when is_list(friends) do
    friends
    |> Enum.map(fn f -> render("friend", f) end)
  end

  def render("friend", friend) do
    %{
      first_name: friend.first_name,
      last_name: friend.last_name,
      username: friend.username,
      id: friend.id
    }
  end
end
