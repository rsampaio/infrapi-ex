defmodule Infrapi.Volume do
  use Infrapi.Web, :model

  schema "volumes" do
    field :path, :string
    field :host_path, :string
    belongs_to :service, Infrapi.Service

    timestamps
  end

  @required_fields ~w(path)
  @optional_fields ~w(host_path)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def for_service(query, service) do
    from c in query,
    join: p in assoc(c, :service),
    where: p.id == ^service.id,
    select: c
  end
end
