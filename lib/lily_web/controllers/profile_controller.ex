defmodule LilyWeb.ProfileController do
  use LilyWeb, :controller

  def show(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> render("show.json", user: user)
  end
end
