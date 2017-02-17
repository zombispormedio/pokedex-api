defmodule PokedexApi.FavView do
  use PokedexApi.Web, :view
  
  def render("limit_exceeded.json", _assigns) do
    %{errors: [%{message: "Límite excedido de favoritos"}], type: "limit_exceeded"}
  end

end