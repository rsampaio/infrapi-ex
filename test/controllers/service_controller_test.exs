defmodule Infrapi.ServiceControllerTest do
  use Infrapi.ConnCase

  alias Infrapi.Service
  alias Infrapi.Project
  alias Infrapi.User
  @valid_attrs %{name: "service", image: "image", env: ["A=1"], volumes: [%{path: "/test"}]}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{}
    {:ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)
    conn = put_req_header(conn, "authorization", jwt)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_service_path(conn, :index, project)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{project_id: project.id}
    conn = get conn, project_service_path(conn, :show, project, service)
    assert json_response(conn, 200)["data"] == %{"id" => service.id,
      "name" => service.name, "env" => [], "volumes" => [], "ports" => [],
      "image" => nil, "project_id" => service.project_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_service_path(conn, :show, project, -1)
    assert json_response(conn, 404)["errors"]["detail"] == "Page not found"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = post conn, project_service_path(conn, :create, project), service: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Service, Map.delete(@valid_attrs, :volumes))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = post conn, project_service_path(conn, :create, project), service: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{project_id: project.id}
    conn = put conn, project_service_path(conn, :update, project, service), service: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Service, Map.delete(@valid_attrs, :volumes))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    conn = put conn, project_service_path(conn, :update, project, service), service: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    conn = delete conn, project_service_path(conn, :delete, project, service)
    assert response(conn, 204)
    refute Repo.get(Service, service.id)
  end
end
