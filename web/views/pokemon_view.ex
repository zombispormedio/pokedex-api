defmodule PokedexApi.PokemonView do
  use PokedexApi.Web, :view

  alias PokedexApi.TypeView

  def render("index.json", %{pokemons: pokemons}) do
    %{data: render_many(pokemons, PokedexApi.PokemonView, "pokemon.json")}
  end

  def render("show.json", %{pokemon: pokemon}) do
    %{data: render_one(pokemon, PokedexApi.PokemonView, "pokemon.json")}
  end

  def render("pokemon.json", %{pokemon: pokemon}) do
    %{type1: type1, type2: type2} = pokemon
    %{
      id: pokemon.id,
      name: pokemon.name,
      description: pokemon.description,
      type1: TypeView.render("type.json", %{type: type1}),
      type2: TypeView.render("type.json", %{type: type2}),
      evolution: pokemon.evolution || "",
      fav: Enum.count(pokemon.favs) == 1,
      sprite: pokemon.sprite || "", 
      insertedAt: pokemon.inserted_at
    }
  end

  def render("not_found.json",  %{params: params}) do
    %{errors: [%{message: "Pokemon no encontrado", params: params}], type: "not_found"}
  end

  def render("custom.json", %{data: data}) do
    %{data: data}
  end
end
