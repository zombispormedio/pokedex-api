defmodule PokedexApi.Repo.Migrations.InsertDataToType do
  use Ecto.Migration

  alias PokedexApi.Repo
  alias PokedexApi.Type

  def up do
    {:ok, result}=File.read "./priv/repo/types"
 
    String.split(result, "\n")
    |> Enum.map(&(String.trim(&1)))
    |> Enum.each(&(Repo.insert! %Type{name: &1})) 
  end

   def down do
    Repo.delete_all(Type)
  end
end
