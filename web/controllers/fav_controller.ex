defmodule PokedexApi.FavController do
  use PokedexApi.Web, :controller

   alias PokedexApi.Authenticator
   alias PokedexApi.Fav
   alias PokedexApi.Pokemon
   alias PokedexApi.PokemonView

  def update(conn, %{"id" => pokemon_id}) do
    user = Authenticator.resolve(conn)
    query = from f in Fav, where: f.user_id == ^user.id and f.pokemon_id == ^pokemon_id
    fav = Repo.one(query)
    cond do
      fav != nil ->
        Repo.delete!(fav)
        pokemon = Repo.get(Pokemon, pokemon_id) |> load_pokemon(user.id)
        render(conn, PokemonView, "show.json", pokemon: pokemon)
      true -> before_create(conn, user_id: user.id, pokemon_id: pokemon_id)
    end
  end

  defp before_create(conn, [user_id: user_id, pokemon_id: pokemon_id]) do
    count = Repo.aggregate(from(f in Fav, where: f.user_id == ^user_id), :count, :id )
    cond do
      count >= 10 -> render(conn, "limit_exceeded.json")
      true -> create(conn, %{user_id: user_id, pokemon_id: pokemon_id})
    end
  end

  defp create(conn, params) do
    changeset = %Fav{} |> load |> Fav.changeset(params)
    case Repo.insert(changeset) do
      {:ok, fv} ->
        pokemon =  get_pokemon_by_fv(fv) |> load_pokemon(params.user_id)
        render(conn, PokemonView, "show.json", pokemon: pokemon)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp get_pokemon_by_fv(fv) do
    Repo.preload(fv, :pokemon).pokemon
  end
  
  defp load_pokemon(pokemon, user_id) do
    pokemon
    |> Repo.preload(:type1) 
    |> Repo.preload(:type2)
    |> Repo.preload(favs: from(f in Fav, where: f.user_id == ^user_id))
  end

  defp load(fav) do
    fav |> Repo.preload(:user) |> Repo.preload(:pokemon)  
  end
end