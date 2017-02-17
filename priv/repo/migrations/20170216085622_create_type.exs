defmodule PokedexApi.Repo.Migrations.CreateType do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :name, :string

      timestamps()
    end
    create index(:types, [:name], unique: true)

  end
end
