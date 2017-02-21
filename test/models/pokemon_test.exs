defmodule PokedexApi.PokemonTest do
  use PokedexApi.ModelCase

  alias PokedexApi.Pokemon

  @valid_attrs %{"name" => "Dewpider", "description" => "Se arrastra hacia la tierra en busca de comida. Su burbuja de agua le permite respirar y proteger su suave cabeza. Cuando encuentra enemigos o presas potenciales", 
                  "evolution" => "Araquanid", "type1" => 1 , "type2" => 18 }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pokemon.changeset(%Pokemon{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pokemon.changeset(%Pokemon{}, @invalid_attrs)
    refute changeset.valid?
  end
end
