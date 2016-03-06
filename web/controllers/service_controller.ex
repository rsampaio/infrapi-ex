defmodule Infrapi.ServiceController do
  use Infrapi.Web, :controller

  alias Infrapi.Service
  alias Infrapi.Project

  plug :scrub_params, "service" when action in [:create, :update]

  def index(conn, %{"project_id" => project_id}) do
    project = Project
    |> Project.by_name_or_id(project_id)
    |> Repo.one

    services = Service
    |> Service.for_project(project)
    |> Repo.all
    |> Repo.preload(:volumes)
    render(conn, "index.json", services: services)
  end

  def create(conn, %{"project_id" => project_id, "service" => service_params}) do
    project = Project
    |> Project.by_name_or_id(project_id)
    |> Repo.one
    service_params = Map.merge(service_params, %{"project_id" => project.id})
    changeset = Service.changeset(%Service{}, service_params)

    case Repo.insert(changeset) do
      {:ok, service} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_service_path(conn, :show, project, service))
        |> render("show.json", service: service)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    service = Service
    |> Service.by_name_or_id(id)
    |> Repo.one

    if service do
      service = service
      |> Repo.preload(:volumes)
      render(conn, "show.json", service: service)
    else
      conn
      |> put_status(:not_found)
      |> render(Infrapi.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => id, "service" => service_params}) do
    service = Service
    |> Service.by_name_or_id(id)
    |> Repo.one
    |> Repo.preload(:volumes)
    changeset = Service.changeset(service, service_params)

    case Repo.update(changeset) do
      {:ok, service} ->
        render(conn, "show.json", service: service)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    service = Service
    |> Service.by_name_or_id(id)
    |> Repo.one
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(service)

    send_resp(conn, :no_content, "")
  end
end
