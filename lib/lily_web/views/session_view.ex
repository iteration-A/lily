defmodule LilyWeb.SessionView do
  use LilyWeb, :view

  def render("200.json", _assigns) do 
    %{ok: true}
  end

  def render("400.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
