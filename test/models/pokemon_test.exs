defmodule PokedexApi.PokemonTest do
  use PokedexApi.ModelCase

  alias PokedexApi.Pokemon

  @valid_attrs %{description: "some content", evolution: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pokemon.changeset(%Pokemon{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pokemon.changeset(%Pokemon{}, @invalid_attrs)
    refute changeset.valid?
  end
end
