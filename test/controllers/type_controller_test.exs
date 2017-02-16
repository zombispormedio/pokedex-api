defmodule PokedexApi.TypeControllerTest do
  use PokedexApi.ConnCase

  alias PokedexApi.Type
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, type_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    type = Repo.insert! %Type{}
    conn = get conn, type_path(conn, :show, type)
    assert json_response(conn, 200)["data"] == %{"id" => type.id,
      "name" => type.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, type_path(conn, :create), type: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Type, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, type_path(conn, :create), type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    type = Repo.insert! %Type{}
    conn = put conn, type_path(conn, :update, type), type: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Type, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    type = Repo.insert! %Type{}
    conn = put conn, type_path(conn, :update, type), type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    type = Repo.insert! %Type{}
    conn = delete conn, type_path(conn, :delete, type)
    assert response(conn, 204)
    refute Repo.get(Type, type.id)
  end
end
