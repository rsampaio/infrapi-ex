defmodule Infrapi.ServiceTest do
  use Infrapi.ModelCase

  alias Infrapi.Service

  @valid_attrs %{name: "service", image: "image", env: "A=1 B=2", ports: ["8080", "5000"], project_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Service.changeset(%Service{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Service.changeset(%Service{}, @invalid_attrs)
    refute changeset.valid?
  end
end
