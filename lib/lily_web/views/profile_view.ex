defmodule LilyWeb.ProfileView do
  use LilyWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render("user.json", user: user)}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      username: user.username
    }
  end
end
