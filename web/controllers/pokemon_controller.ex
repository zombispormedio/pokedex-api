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
    get_by_id(id, &(render(&1, "show.json", pokemon: load(&2, user)))).(conn)
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
        send_resp(conn, :no_content, "")
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
    count = Repo.aggregate(Pokemon, :count, :id)
    %{limit: limit, offset: offset, page: page} = Pokemon.paginate(params)
    max_pages = Float.ceil(count / limit)
    cond do
      max_pages < page -> []
      true -> get_pokemons(params, user, limit: limit, offset: offset)
    end
  end
  
  defp get_pokemons(params, user, [limit: limit, offset: offset]) do
    query = from p in Pokemon, preload: [:type1, :type2], limit: ^limit, offset: ^offset
    query = case Map.has_key?(params, "q") do
      true ->(
        %{"q" => q} = params
        name = "%#{q}%"
        from p in query,  where: like(p.name, ^name)
        )
      _ -> query
    end
    pokemons = case Map.has_key?(params, "f") do
      true -> Repo.preload(user, pokemons: query).pokemons
      _ -> Repo.all(query)
    end
    Repo.preload(pokemons, favs: from(f in Fav, where: f.user_id == ^user.id))
  end
  
  defp put_resp_authorization(conn, user) do
    put_resp_header(conn, "Authorization", user.token)
  end
end
