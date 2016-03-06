defmodule Infrapi.Repo.Migrations.ProjectAddDomain do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :domain, :string
    end
  end
end
