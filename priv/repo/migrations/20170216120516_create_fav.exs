defmodule PokedexApi.Repo.Migrations.CreateFav do
  use Ecto.Migration

  def change do
    create table(:favs) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :pokemon_id, references(:pokemons, on_delete: :delete_all)

      timestamps()
    end
    create index(:favs, [:user_id])
    create index(:favs, [:pokemon_id])

  end
end
