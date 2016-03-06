defmodule Infrapi.UserView do
  use Infrapi.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Infrapi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      encrypted_password: user.encrypted_password}
  end
end
