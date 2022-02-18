defmodule LilyWeb.UserController do
  use LilyWeb, :controller

  alias Lily.Settings
  alias Lily.Accounts
  alias Lily.Accounts.User
  alias LilyWeb.Plugs.Auth

  action_fallback LilyWeb.FallbackController

  plug LilyWeb.Plugs.Auth when action in ~w(update delete)a
  plug :guard_registration when action in ~w(create)a

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.current_user

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      conn
      |> Auth.logout()
      |> send_resp(:no_content, "")
    end
  end

  defp guard_registration(conn, _params) do
    unless Settings.allow_registration() do
      conn
      |> halt()
      |> send_resp(:forbidden, "Registration is not allow at the moment.")
    end

    conn
  end
end
