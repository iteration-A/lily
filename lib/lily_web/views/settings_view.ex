defmodule LilyWeb.SettingsView do
  use LilyWeb, :view
  alias LilyWeb.SettingsView

  def render("index.json", %{settings: settings}) do
    %{
      data: %{
        allow_registration: settings.allow_registration
      }
    }
  end
end
