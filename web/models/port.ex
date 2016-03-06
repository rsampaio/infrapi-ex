defmodule Infrapi.Port do
  use Infrapi.Web, :model
  use Infrapi.Util

  schema "ports" do
    field :port, :string
    belongs_to :project, Infrapi.Project

    timestamps
  end

  @required_fields ~w(port project_id)
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
