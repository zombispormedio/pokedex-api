defmodule PokedexApi.FavTest do
  use PokedexApi.ModelCase

  alias PokedexApi.Fav
  alias PokedexApi.Pokemon
  alias PokedexApi.User

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    pokemon = Repo.insert!(%Pokemon{})
    user = Repo.insert!(%User{})
    changeset = Fav.changeset(%Fav{}, %{pokemon_id: pokemon.id, user_id: user.id})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Fav.changeset(%Fav{}, @invalid_attrs)
    refute changeset.valid?
  end
end
