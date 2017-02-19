defmodule PokedexApi.PokeApi do
     use Tesla
     
     plug Tesla.Middleware.BaseUrl, "http://pokeapi.co/api/v2"
     plug Tesla.Middleware.JSON
     
     def sprite(name) do
         res = get("/pokemon/#{String.downcase(name)}")
         cond do
             res.status == 200 -> extract_sprite(res.body)
             true -> ""
         end
    end

    defp extract_sprite(%{"sprites" => sprites} ) do
        sprites["front_default"]
    end
end