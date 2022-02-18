defmodule LilyWeb.SettingsController do 
  use LilyWeb, :controller

  alias Lily.Settings

  def index(conn, _params) do 
    render(conn, "index.json", settings: Settings.get_settings())
  end
end
