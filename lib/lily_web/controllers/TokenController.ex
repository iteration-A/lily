defmodule LilyWeb.TokenController do 
  use LilyWeb, :controller

  def create(conn, _params) do 
    user = conn.assigns.current_user
    token = Phoenix.Token.sign(LilyWeb.Endpoint, "auth salt", user.id)
    render(conn, "create.json", token: token)
  end
end
