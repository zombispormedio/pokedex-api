defmodule PokedexApi.Repo.Migrations.AddSeveralIndexes do
  use Ecto.Migration

  def change do
    create index(:users, [:access_token], unique: true)
    create index(:types, [:name], unique: true)
  end
end
