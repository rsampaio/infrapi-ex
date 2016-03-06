defmodule Infrapi.VolumeView do
  use Infrapi.Web, :view

  def render("index.json", %{volumes: volumes}) do
    %{data: render_many(volumes, Infrapi.VolumeView, "volume.json")}
  end

  def render("show.json", %{volume: volume}) do
    %{data: render_one(volume, Infrapi.VolumeView, "volume.json")}
  end

  def render("volume.json", %{volume: volume}) do
    %{
        id: volume.id,
        path: volume.path,
        host_path: volume.host_path
    }
  end
end
