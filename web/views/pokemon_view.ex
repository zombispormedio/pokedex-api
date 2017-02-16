defmodule PokedexApi.PokemonView do
  use PokedexApi.Web, :view

  def render("index.json", %{pokemons: pokemons}) do
    %{data: render_many(pokemons, PokedexApi.PokemonView, "pokemon.json")}
  end

  def render("show.json", %{pokemon: pokemon}) do
    %{data: render_one(pokemon, PokedexApi.PokemonView, "pokemon.json")}
  end

  def render("pokemon.json", %{pokemon: pokemon}) do
    %{id: pokemon.id,
      name: pokemon.name,
      description: pokemon.description,
      type1: pokemon.type1,
      type2: pokemon.type2,
      evolution: pokemon.evolution}
  end
end
