defmodule LilyWeb.ChatView do
  use LilyWeb, :view

  def render("create.json", %{chat_id: chat_id}) do
    %{data: %{chat_id: chat_id}}
  end

  def render("error.json", %{reason: reason}) do
    %{error: reason}
  end
end
