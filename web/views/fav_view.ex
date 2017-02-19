defmodule PokedexApi.FavView do
  use PokedexApi.Web, :view
  
  def render("limit_exceeded.json", _assigns) do
    %{errors: [%{message: "Límite excedido de favoritos. Sólo puedes tener 10 marcados"}], type: "limit_exceeded"}
  end

end