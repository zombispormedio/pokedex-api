defmodule PokedexApi.AutocompleteController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Pokemon
  
  def index(conn, params) do
      data = case Map.has_key?(params, "q") do
          true ->
              %{"q" => q} = params
              create_query(q)
        _ -> []
    end
    render(conn, PokedexApi.PokemonView, "custom.json", data: data)
  end
  
  def create_query(q) do
      cond do
          String.first(q) != nil -> 
              name = "%#{q}%"
              query = from p in Pokemon,  where: like(p.name, ^name), select: p.name
              Repo.all(query)
        true -> []
        end
    end

end