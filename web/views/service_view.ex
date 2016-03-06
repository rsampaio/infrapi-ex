defmodule Infrapi.ServiceView do
  use Infrapi.Web, :view

  def render("index.json", %{services: services}) do
    %{data: render_many(services, Infrapi.ServiceView, "service.json")}
  end

  def render("show.json", %{service: service}) do
    %{data: render_one(service, Infrapi.ServiceView, "service.json")}
  end

  def render("service.json", %{service: service}) do
    %{id: service.id,
      name: service.name,
      image: service.image,
      env: service.env,
      ports: service.ports,
      volumes: render_many(service.volumes, Infrapi.VolumeView, "volume.json"),
      project_id: service.project_id}
  end
end
