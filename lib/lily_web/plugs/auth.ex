defmodule LilyWeb.Plugs.Auth do
  import Plug.Conn
  alias Lily.Accounts

  def init(default), do: default

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)

    case user do
      nil ->
        conn
        |> halt()
        |> send_resp(:unauthorized, "")

      user ->
        conn
        |> assign(:current_user, user)
    end
  end

  def login(conn, user_id) do
    conn
    |> put_session(:user_id, user_id)
  end

  def logout(conn) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
  end
end
