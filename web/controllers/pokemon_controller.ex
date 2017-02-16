defmodule PokedexApi.PokemonController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Pokemon

  def index(conn, _params) do
    pokemons = Repo.all(Pokemon)
    render(conn, "index.json", pokemons: pokemons)
  end

  def create(conn, %{"pokemon" => pokemon_params}) do
    changeset = Pokemon.changeset(%Pokemon{}, pokemon_params)

    case Repo.insert(changeset) do
      {:ok, pokemon} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pokemon_path(conn, :show, pokemon))
        |> render("show.json", pokemon: pokemon)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pokemon = Repo.get!(Pokemon, id)
    render(conn, "show.json", pokemon: pokemon)
  end

  def update(conn, %{"id" => id, "pokemon" => pokemon_params}) do
    pokemon = Repo.get!(Pokemon, id)
    changeset = Pokemon.changeset(pokemon, pokemon_params)

    case Repo.update(changeset) do
      {:ok, pokemon} ->
        render(conn, "show.json", pokemon: pokemon)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pokemon = Repo.get!(Pokemon, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pokemon)

    send_resp(conn, :no_content, "")
  end
end
