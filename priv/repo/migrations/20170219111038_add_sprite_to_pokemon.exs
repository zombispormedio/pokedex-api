defmodule PokedexApi.Repo.Migrations.AddSpriteToPokemon do
  use Ecto.Migration

  def change do
    alter table(:pokemons) do
      add :sprite, :string
    end
  end
end
