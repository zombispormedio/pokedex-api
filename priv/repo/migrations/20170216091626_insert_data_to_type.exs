defmodule PokedexApi.Repo.Migrations.InsertDataToType do
  use Ecto.Migration

  alias PokedexApi.Repo
  alias PokedexApi.Type

  def up do
    ~w{Bicho Dragón Hada Fuego Fantasma Tierra Normal Psíquico Acero Siniestro Eléctrico Lucha Volador Planta Hielo Veneno Roca Agua}
    |> Enum.each(&(Repo.insert! %Type{name: &1})) 
  end

   def down do
    Repo.delete_all(Type)
  end
end
