defmodule Infrapi.PortTest do
  use Infrapi.ModelCase

  alias Infrapi.Port

  @valid_attrs %{port: "8080", project_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Port.changeset(%Port{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Port.changeset(%Port{}, @invalid_attrs)
    refute changeset.valid?
  end
end
