defmodule PokedexApi.PokemonControllerTest do
  use PokedexApi.ConnCase

  alias PokedexApi.Pokemon
  @valid_attrs %{description: "some content", evolution: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pokemon_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = get conn, pokemon_path(conn, :show, pokemon)
    assert json_response(conn, 200)["data"] == %{"id" => pokemon.id,
      "name" => pokemon.name,
      "description" => pokemon.description,
      "type1" => pokemon.type1,
      "type2" => pokemon.type2,
      "evolution" => pokemon.evolution}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pokemon_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pokemon_path(conn, :create), pokemon: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Pokemon, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pokemon_path(conn, :create), pokemon: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = put conn, pokemon_path(conn, :update, pokemon), pokemon: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pokemon, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = put conn, pokemon_path(conn, :update, pokemon), pokemon: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pokemon = Repo.insert! %Pokemon{}
    conn = delete conn, pokemon_path(conn, :delete, pokemon)
    assert response(conn, 204)
    refute Repo.get(Pokemon, pokemon.id)
  end
end
