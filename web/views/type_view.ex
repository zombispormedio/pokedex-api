defmodule PokedexApi.TypeView do
  use PokedexApi.Web, :view
  alias NaiveDateTime, as: T

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

  def render("hello.json", _assigns) do
    %{data: ["Hello Everybody, this is Pokedex Watch: #{T.utc_now |> T.to_string}"]}
  end

end
