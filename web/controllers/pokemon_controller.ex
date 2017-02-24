defmodule PokedexApi.PokemonController do
  use PokedexApi.Web, :controller

  alias PokedexApi.Pokemon
  alias PokedexApi.Fav
  alias PokedexApi.Authenticator

  def index(conn, params) do
    user = Authenticator.resolve(conn)
    pokemons = paginate_pokemons(params, user)
    conn
    |> put_resp_authorization(user)
    |> render("index.json", pokemons: pokemons)
  end

  def create(conn, params) do
    user = Authenticator.resolve(conn)
    pokemon = load_types(%Pokemon{})
    changeset = Pokemon.changeset(pokemon, params["pokemon"] || %{})
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
    changeset = Pokemon.changeset(load_types(pokemon), params)
    
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
      true -> 
        fn conn ->
           conn
            |> put_status(:not_found)
            |> render( "not_found.json", params: %{id: id}) 
        end
    end
  end
  
  def paginate_pokemons(params, user) do
    builder = build_query(params, user)
    case builder.overflow do
       true -> []
      _ -> get_pokemons(builder, user)
    end
  end
  
  defp get_pokemons(builder, user) do
    query = builder.query
    pokemons = case builder.only_favs do
                  true -> Repo.preload(user, pokemons: query).pokemons
                  _ -> Repo.all(query)
              end
    Repo.preload(pokemons, favs: from(f in Fav, where: f.user_id == ^user.id))
  end

  defp build_query(params, user) do
    from(p in Pokemon)
    |> create_builder(params)
    |> resolve_search(params)
    |> resolve_overflow(user)
    |> build_query
  end

  defp create_builder(query, params) do
    Pokemon.paginate(params)
    |> Map.put(:query, query)
    |> Map.put(:only_favs, Map.has_key?(params, "f"))
    |> Map.put(:search, Map.has_key?(params, "q"))
  end

  defp resolve_search(builder, params) do
    case builder.search do
      true ->
        %{"q" => q} = params
        name = "%#{q}%"
        new_query = from(p in builder.query,  where: like(p.name, ^name))
        %{builder | query: new_query}
        _ -> builder
    end
  end

  defp resolve_overflow(b, user) do
    count = case b.only_favs do
      true -> Repo.preload(user, pokemons: b.query).pokemons |> Enum.count
      _ -> Repo.aggregate(b.query, :count, :id)
    end
    overflow = Float.ceil(count / b.limit) < b.page
    Map.put(b, :overflow, overflow)
  end

  defp build_query(b) do
    case b.overflow do
      false -> 
        query = from p in b.query, preload: [:type1, :type2], 
        limit: ^b.limit, offset: ^b.offset, order_by: [desc: p.inserted_at]
        %{b| query: query}
      _ -> b
    end
  end
  
  defp put_resp_authorization(conn, user) do
    put_resp_header(conn, "authorization", user.token)
  end
end
