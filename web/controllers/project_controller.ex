defmodule Infrapi.ProjectController do
  use Infrapi.Web, :controller

  alias Infrapi.Project

  plug :scrub_params, "project" when action in [:create, :update]

  def index(conn, _params) do
    projects = Repo.all(Project)
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_path(conn, :show, project))
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Project
    |> Project.by_name_or_id(id)
    |> Repo.one
    if project != nil do
      render(conn, "show.json", project: project)
    else
      conn
      |> put_status(:not_found)
      |> render(Infrapi.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Project
    |> Project.by_name_or_id(id)
    |> Repo.one
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        render(conn, "show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Infrapi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    send_resp(conn, :no_content, "")
  end
end
