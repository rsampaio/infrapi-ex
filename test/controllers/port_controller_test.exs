defmodule Infrapi.PortControllerTest do
  use Infrapi.ConnCase

  alias Infrapi.Port
  alias Infrapi.Project
  alias Infrapi.User
  @valid_attrs %{port: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{}
    {:ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)
    conn = put_req_header(conn, "authorization", jwt)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_port_path(conn, :index, project)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    port = Repo.insert! %Port{}
    conn = get conn, project_port_path(conn, :show, project, port)
    assert json_response(conn, 200)["data"] == %{"id" => port.id,
      "port" => port.port,
      "project_id" => port.project_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    project = Repo.insert! %Project{}
    assert_error_sent 404, fn ->
      get conn, project_port_path(conn, :show, project, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = post conn, project_port_path(conn, :create, project), port: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Port, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = post conn, project_port_path(conn, :create, project), port: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    port = Repo.insert! %Port{project_id: project.id}
    conn = put conn, project_port_path(conn, :update, project, port), port: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Port, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    port = Repo.insert! %Port{}
    conn = put conn, project_port_path(conn, :update, project, port), port: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    port = Repo.insert! %Port{}
    conn = delete conn, project_port_path(conn, :delete, project, port)
    assert response(conn, 204)
    refute Repo.get(Port, port.id)
  end
end
