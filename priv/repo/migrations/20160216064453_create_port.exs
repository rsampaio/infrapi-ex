defmodule Infrapi.Repo.Migrations.CreatePort do
  use Ecto.Migration

  def change do
    create table(:ports) do
      add :port, :string
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps
    end
    create index(:ports, [:project_id])

  end
end
