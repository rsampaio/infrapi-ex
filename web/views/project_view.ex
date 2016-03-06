defmodule Infrapi.ProjectView do
  use Infrapi.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, Infrapi.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, Infrapi.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      domain: project.domain}
  end
end
