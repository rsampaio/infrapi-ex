defmodule Infrapi.ProjectTest do
  use Infrapi.ModelCase

  alias Infrapi.Project

  @valid_attrs %{name: "project_name", domain: "test.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
