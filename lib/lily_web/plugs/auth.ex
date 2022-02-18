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
end
