defmodule PokedexApi.UserTest do
  use PokedexApi.ModelCase

  alias PokedexApi.User

  @valid_attrs %{access_token: "some content", last_access: %{day: 17, month: 4, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
