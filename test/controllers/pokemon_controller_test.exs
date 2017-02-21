defmodule PokedexApi.PokemonControllerTest do
  use PokedexApi.ConnCase

  alias PokedexApi.Pokemon
  
  @valid_pokemon %Pokemon{name: "Dewpider", description: "Se arrastra hacia la tierra en busca de comida. Su burbuja de agua le permite respirar y proteger su suave cabeza. Cuando encuentra enemigos o presas potenciales", 
                  evolution: "Araquanid", type1_id: 1 , type2_id: 18 }
  @valid_attrs %{description: @valid_pokemon.description, evolution: @valid_pokemon.evolution, name: @valid_pokemon.name, 
                type1: @valid_pokemon.type1_id, type2: @valid_pokemon.type2_id}
  @get_attrs %{description: @valid_pokemon.description, evolution: @valid_pokemon.evolution, name: @valid_pokemon.name, 
                type1_id: @valid_pokemon.type1_id, type2_id: @valid_pokemon.type2_id}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pokemon_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pokemon = Repo.insert!(@valid_pokemon) |> Repo.preload([:type1, :type2])
    conn = get conn, pokemon_path(conn, :show, pokemon)
    data = json_response(conn, 200)["data"]
    assert data["id"] ==  pokemon.id
    assert data["name"] == pokemon.name
    assert data["description"] == pokemon.description
    assert data["fav"] == false
    assert data["sprite"] == ""
    assert data["insertedAt"] == NaiveDateTime.to_iso8601(pokemon.inserted_at)
    assert data["type1"]["id"] == pokemon.type1.id
    assert data["type2"]["id"] == pokemon.type2.id
    assert data["evolution"] == pokemon.evolution
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, pokemon_path(conn, :show, -1)
    assert json_response(conn, 404)["errors"] != %{}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pokemon_path(conn, :create), pokemon: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Pokemon, @get_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pokemon_path(conn, :create), pokemon: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = put conn, pokemon_path(conn, :update, pokemon), pokemon: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pokemon, @get_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = put conn, pokemon_path(conn, :update, pokemon), pokemon: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = delete conn, pokemon_path(conn, :delete, pokemon)
    assert response(conn, 200)
    refute Repo.get(Pokemon, pokemon.id)
  end
end
