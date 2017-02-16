defmodule PokedexApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :access_token, :string
      add :last_access, :date

      timestamps()
    end

  end
end
