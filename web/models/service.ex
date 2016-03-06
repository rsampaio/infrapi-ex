defmodule Infrapi.Service do
  use Infrapi.Web, :model
  use Infrapi.Util

  schema "services" do
    field :name, :string

    # This should be a mapping from docker-compose.yml
    # at least what I need for now
    field :image, :string
    field :env, :string
    field :ports, {:array, :string}

    has_many :links,   Infrapi.Service
    has_many :volumes, Infrapi.Volume, on_replace: :delete

    belongs_to :project, Infrapi.Project

    timestamps
  end

  @required_fields ~w(name image ports project_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:volumes, required: false)
  end
end
