defmodule Edges.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :person, :string, null: false

      timestamps()
    end

    create unique_index(:sources, [:person])
  end
end
