defmodule LilyWeb.MessageView do
  use LilyWeb, :view

  def render("index.json", %{messages: messages}) do
    %{data: render("messages", messages: messages)}
  end

  def render("messages", %{messages: messages}) do
    for message <- messages, do: render("message", message: message)
  end

  def render("message", %{message: message}) do
    %{
      to: message.to,
      from: message.from,
      body: message.body,
      id: message.id
    }
  end
end
