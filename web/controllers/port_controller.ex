defmodule Infrapi.PortController do
  use Infrapi.Web, :controller

  alias Infrapi.Port
  alias Infrapi.Project

  plug :scrub_params, "port" when action in [:create, :update]

  def index(conn, %{"project_id" => project_id}) do
    project = Project
    |> Project.by_name_or_id(project_id)
    |> Repo.one

    ports = Port
    |> Port.for_project(project)
    |> Repo.all
    render(conn, "index.json", ports: ports)
  end

  def create(conn, %{"project_id" => project_id, "port" => port_params}) do
    project = Project
    |> Project.by_name_or_id(project_id)
    |> Repo.one
    port_params = Map.merge(port_params, %{"project_id" => project.id})
    changeset = Port.changeset(%Port{}, port_params)

    case Repo.insert(changeset) do
      {:ok, port} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_port_path(conn, :show, project, port))
        |> render("show.json", port: port)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    port = Repo.get!(Port, id)
    render(conn, "show.json", port: port)
  end

  def update(conn, %{"id" => id, "port" => port_params}) do
    port = Repo.get!(Port, id)
    changeset = Port.changeset(port, port_params)

    case Repo.update(changeset) do
      {:ok, port} ->
        render(conn, "show.json", port: port)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    port = Repo.get!(Port, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(port)

    send_resp(conn, :no_content, "")
  end
end
