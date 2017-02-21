defmodule PokedexApi.PokemonController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Pokemon
  alias PokedexApi.Type
  alias PokedexApi.Fav
  alias PokedexApi.Authenticator

  def index(conn, params) do
    user = Authenticator.resolve(conn)
    pokemons = paginate_pokemons(params, user)
    conn
    |> put_resp_authorization(user)
    |> render("index.json", pokemons: pokemons)
  end

  def create(conn, %{"pokemon" => pokemon_params}) do
    user = Authenticator.resolve(conn)
    pokemon = load_types(%Pokemon{})
    changeset = build_change(pokemon, pokemon_params)
    case Repo.insert(changeset) do
      {:ok, pokemon} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pokemon_path(conn, :show, pokemon))
        |> render("show.json", pokemon: load(pokemon, user))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Authenticator.resolve(conn)
    r = &(render(&1, "show.json", pokemon: load(&2, user)))
    get_by_id(id, r).(conn |> put_resp_authorization(user))
  end

  def update(conn, %{"id" => id, "pokemon" => params}) do
    get_by_id(id, &(process_update(&1, &2,params))).(conn)
  end

  defp process_update(conn, pokemon, params) do
    changeset = build_change(load_types(pokemon), params)
    
    case Repo.update(changeset) do
      {:ok, pokemon} -> show(conn, %{"id" => pokemon.id})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PokedexApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pokemon = Repo.get(Pokemon, id) 
    cond do
      pokemon != nil -> 
        Repo.delete!(pokemon)
        render(conn, "custom.json", data: %{message: "Hecho ;)"})
      true ->
        render(conn, "not_found.json", params: %{id: id})
    end
  end
  
  defp load_types(pokemon) do
    pokemon |> Repo.preload(:type1) |> Repo.preload(:type2)
  end
  
  defp load(pokemon, user) do
    pokemon |> load_types |>  Repo.preload(favs: from(f in Fav, where: f.user_id == ^user.id))
  end
  
  def get_by_id(id, callback) do
    pokemon = Repo.one( from u in Pokemon, where: u.id == ^id)
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
  
  def paginate_pokemons(params, user) do
    result= get_query_and_metadata(params, user)
    case result.overflow do
       true -> []
      _ -> get_pokemons(result, user)
    end
  end
  
  defp get_pokemons(result, user) do
    query = result.query
    pokemons = case result.only_favs do
                  true -> Repo.preload(user, pokemons: query).pokemons
                  _ -> Repo.all(query)
              end
    Repo.preload(pokemons, favs: from(f in Fav, where: f.user_id == ^user.id))
  end

  defp get_query_and_metadata(params, user) do
    query = from p in Pokemon
    query = case Map.has_key?(params, "q") do
              true ->
                %{"q" => q} = params
                name = "%#{q}%"
                from p in query,  where: like(p.name, ^name)
              _ -> query
          end
    [limit: limit, offset: offset, only_favs: only_favs, page: page] = get_metadata(params)
    count = case only_favs do
      true -> Repo.preload(user, pokemons: query).pokemons |> Enum.count
      _ -> Repo.aggregate(query, :count, :id)
    end
    overflow = Float.ceil(count / limit) < page
    query = case overflow do
              false -> from p in query, preload: [:type1, :type2], limit: ^limit, offset: ^offset, order_by: [desc: p.inserted_at]
              _ -> query 
            end
    %{query: query, overflow: overflow, only_favs: only_favs}
  end

  defp get_metadata(params) do
    only_favs = Map.has_key?(params, "f")
    %{limit: limit, offset: offset, page: page} = Pokemon.paginate(params)
    [limit: limit, offset: offset, only_favs: only_favs, page: page]
  end
  
  defp put_resp_authorization(conn, user) do
    put_resp_header(conn, "authorization", user.token)
  end
end
