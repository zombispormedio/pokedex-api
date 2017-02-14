defmodule PokedexApi.PageController do
  use PokedexApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
