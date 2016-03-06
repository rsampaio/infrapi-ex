defmodule Infrapi.Project do

  use Infrapi.Web, :model
  use Infrapi.Util

  schema "projects" do
    field :name, :string
    field :domain, :string

    timestamps
  end

  @required_fields ~w(name domain)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
