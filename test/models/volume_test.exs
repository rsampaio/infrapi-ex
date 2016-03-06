defmodule Infrapi.VolumeTest do
  use Infrapi.ModelCase

  alias Infrapi.Volume

  @valid_attrs %{host_path: "some content", path: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Volume.changeset(%Volume{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Volume.changeset(%Volume{}, @invalid_attrs)
    refute changeset.valid?
  end
end
