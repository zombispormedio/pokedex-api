defmodule PokedexApi.TypeController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Type

  def index(conn, _params) do
    types = Repo.all(Type)
    render(conn, "index.json", types: types)
  end
end
