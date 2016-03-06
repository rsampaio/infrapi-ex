defmodule Infrapi.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :image, :string
      add :env, :string
      add :ports, {:array, :string}
      add :project_id, references(:projects, on_delete: :nothing)
      add :link_id, references(:services, on_delete: :nothing)

      timestamps
    end
    create index(:services, [:project_id, :name], unique: true)
    create index(:services, [:project_id])
    create index(:services, [:link_id])

  end
end
