defmodule Infrapi.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string

      timestamps
    end
    create index(:projects, [:name], unique: true)
  end
end
