defmodule PokedexApi.UserTest do
  use PokedexApi.ModelCase

  alias PokedexApi.User


  test "changeset with valid attributes" do
    user = User.create()
    assert Ecto.UUID.cast(user.token) != nil
  end
end
