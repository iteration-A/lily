defmodule LilyWeb.SessionController do
  use LilyWeb, :controller

  alias Lily.Accounts
  alias LilyWeb.Plugs.Auth

  def create(conn, %{"user" => %{"password" => pass, "username" => username}}) do
    case Accounts.authenticate_user(username, pass) do
      {:error, _reason} ->
        conn
        |> halt()
        |> render("400.json", %{message: "Invalid credentials"})

      {:ok, user} ->
        conn
        |> Auth.login(user.id)
        |> render("200.json")
    end
  end

  def delete(conn, _params) do
    Auth.logout(conn)
    |> send_resp(:ok, "")
  end
end
