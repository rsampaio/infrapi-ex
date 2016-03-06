defmodule Infrapi.VolumeController do
  use Infrapi.Web, :controller

  alias Infrapi.Volume
  alias Infrapi.Service

  plug :scrub_params, "volume" when action in [:create, :update]

  def index(conn, %{"service_id" => service_id}) do
    service = Service
    |> Service.by_name_or_id(service_id)
    |> Repo.one

    volumes = Volume
    |> Volume.for_service(service)
    |> Repo.all
    render(conn, "index.json", volumes: volumes)
  end

  def create(conn, %{"project_id" => project_id, "service_id" => service_id, "volume" => volume_params}) do
    volume_params = Map.merge(volume_params, %{"service_id" => service_id})
    changeset = Volume.changeset(%Volume{}, volume_params)

    case Repo.insert(changeset) do
      {:ok, volume} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_service_volume_path(conn, :show, project_id, service_id, volume))
        |> render("show.json", volume: volume)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    volume = Repo.get!(Volume, id)
    render(conn, "show.json", volume: volume)
  end

  def update(conn, %{"id" => id, "volume" => volume_params}) do
    volume = Repo.get!(Volume, id)
    changeset = Volume.changeset(volume, volume_params)

    case Repo.update(changeset) do
      {:ok, volume} ->
        render(conn, "show.json", volume: volume)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    volume = Repo.get!(Volume, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(volume)

    send_resp(conn, :no_content, "")
  end
end
