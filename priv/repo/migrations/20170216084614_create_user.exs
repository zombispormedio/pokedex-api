defmodule PokedexApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :token, :uuid
      add :last_access, :utc_datetime

      timestamps()
    end

  end
end
