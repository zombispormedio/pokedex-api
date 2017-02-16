defmodule PokedexApi.Router do
  use PokedexApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  
   scope "/api", PokedexApi do
    pipe_through :api
    resources "/types", TypeController, only: [:index]
   end
end
