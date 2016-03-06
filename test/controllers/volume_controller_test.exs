defmodule Infrapi.VolumeControllerTest do
  use Infrapi.ConnCase

  alias Infrapi.Volume
  alias Infrapi.Project
  alias Infrapi.Service
  alias Infrapi.User
  @valid_attrs %{host_path: "some content", path: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{}
    {:ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)
    conn = put_req_header(conn, "authorization", jwt)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    conn = get conn, project_service_volume_path(conn, :index, project, service)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    volume = Repo.insert! %Volume{}
    conn = get conn, project_service_volume_path(conn, :show, project, service, volume)
    assert json_response(conn, 200)["data"] == %{"id" => volume.id,
      "path" => volume.path,
      "host_path" => volume.host_path}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    assert_error_sent 404, fn ->
      get conn, project_service_volume_path(conn, :show, project, service, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    conn = post conn, project_service_volume_path(conn, :create, project, service), volume: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Volume, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    conn = post conn, project_service_volume_path(conn, :create, project, service), volume: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    volume = Repo.insert! %Volume{}
    conn = put conn, project_service_volume_path(conn, :update, project, service, volume), volume: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Volume, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    volume = Repo.insert! %Volume{}
    conn = put conn, project_service_volume_path(conn, :update, project, service, volume), volume: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    service = Repo.insert! %Service{}
    volume = Repo.insert! %Volume{}
    conn = delete conn, project_service_volume_path(conn, :delete, project, service, volume)
    assert response(conn, 204)
    refute Repo.get(Volume, volume.id)
  end
end
