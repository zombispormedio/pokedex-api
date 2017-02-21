defmodule PokedexApi.TypeControllerTest do
  use PokedexApi.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, type_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 18
  end
end
