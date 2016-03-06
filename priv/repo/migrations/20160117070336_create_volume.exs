defmodule Infrapi.Repo.Migrations.CreateVolume do
  use Ecto.Migration

  def change do
    create table(:volumes) do
      add :path, :string
      add :host_path, :string
      add :service_id, references(:services, on_delete: :nothing)

      timestamps
    end
    create index(:volumes, [:service_id])

  end
end
