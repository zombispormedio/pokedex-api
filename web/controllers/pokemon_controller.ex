defmodule PokedexApi.PokemonController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Pokemon
  alias PokedexApi.Type

  def index(conn, _params) do
    pokemons = Repo.all(from u in Pokemon, preload: [:type1, :type2])
    render(conn, "index.json", pokemons: pokemons)
  end

  def create(conn, %{"pokemon" => pokemon_params}) do
    pokemon = load(%Pokemon{})
    changeset = build_change(pokemon, pokemon_params)

    case Repo.insert(changeset) do
      {:ok, pokemon} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pokemon_path(conn, :show, pokemon))
        |> render("show.json", pokemon: load(pokemon))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    get_by_id(id, &(render(&1, "show.json", pokemon: &2))).(conn)
  end

  def update(conn, %{"id" => id, "pokemon" => params}) do
    get_by_id(id, &(process_update(&1, &2,params))).(conn)
  end

  defp process_update(conn, pokemon, params) do
    changeset = build_change(pokemon, params)
    case Repo.update(changeset) do
      {:ok, pokemon} ->
        render(conn, "show.json", pokemon: load(pokemon))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pokemon = Repo.get(Pokemon, id) 
    cond do
      pokemon !=nil -> 
        Repo.delete!(pokemon)
        send_resp(conn, :no_content, "")
      true ->
        render(conn, "not_found.json", params: %{id: id})
    end
   
  end

   defp load(pokemon) do
    pokemon |> Repo.preload(:type1) |> Repo.preload(:type2)
   end

  defp get_by_id(id, callback) do
    pokemon = Repo.one( from u in Pokemon, where: u.id == ^id , preload: [:type1, :type2])

    cond do
      pokemon !=nil -> &(callback.(&1, pokemon))
      true -> &(render(&1, "not_found.json", params: %{id: id}))
    end
  end

  defp types() do
    Enum.map(Repo.all(Type), fn item -> item.id end)
  end

  defp build_change(pokemon, params) do
    Pokemon.changeset(pokemon, params, types())
  end
end
