defmodule Edges.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions, primary_key: false) do
      add :id,            :binary_id, primary_key: true
      add :source_id,     references(:sources, on_delete: :nothing, type: :binary_id)
      add :action,        :string, null: false
      add :resource_type, :string, null: false
      add :resource_id,   :string, null: false

      timestamps()
    end

    create index(:actions, :action)
    create index(:actions, [:resource_id, :resource_type])
  end
end
