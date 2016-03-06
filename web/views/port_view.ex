defmodule Infrapi.PortView do
  use Infrapi.Web, :view

  def render("index.json", %{ports: ports}) do
    %{data: render_many(ports, Infrapi.PortView, "port.json")}
  end

  def render("show.json", %{port: port}) do
    %{data: render_one(port, Infrapi.PortView, "port.json")}
  end

  def render("port.json", %{port: port}) do
    %{id: port.id,
      port: port.port,
      project_id: port.project_id}
  end
end
