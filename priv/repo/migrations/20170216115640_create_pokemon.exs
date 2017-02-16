defmodule PokedexApi.Repo.Migrations.CreatePokemon do
  use Ecto.Migration

  def change do
    create table(:pokemons) do
      add :name, :string
      add :description, :text
      add :evolution, :string
      add :type1_id, references(:types, on_delete: :nilify_all)
      add :type2_id, references(:types, on_delete: :nilify_all)

      timestamps()
    end
    create index(:pokemons, [:name], unique: true)
    create index(:pokemons, [:type1_id])
    create index(:pokemons, [:type2_id])

  end
end
