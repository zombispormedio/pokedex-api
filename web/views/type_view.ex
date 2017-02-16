defmodule PokedexApi.TypeView do
  use PokedexApi.Web, :view

  def render("index.json", %{types: types}) do
    %{data: render_many(types, PokedexApi.TypeView, "type.json")}
  end
  
  def render("type.json", %{type: type}) do
    cond do
      type != nil ->   %{id: type.id,
      name: type.name}
      true -> %{}
    end
  
  end
end
