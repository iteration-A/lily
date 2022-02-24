defmodule LilyWeb.TokenView do
  use LilyWeb, :view

  def render("create.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
