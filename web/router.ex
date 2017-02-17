defmodule PokedexApi.Router do
  use PokedexApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  
   scope "/api", PokedexApi do
     pipe_through :api
     resources "/types", TypeController, only: [:index]
     resources "/pokemons", PokemonController, except: [:new, :edit]
     resources "/fav", FavController, only: [:update]
   end
end
