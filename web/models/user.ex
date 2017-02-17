defmodule PokedexApi.User do
  use PokedexApi.Web, :model

  alias PokedexApi.Fav
  alias PokedexApi.User

  schema "users" do
    field :token, Ecto.UUID
    field :last_access, Ecto.DateTime
    has_many :favs, Fav
    has_many :pokemons, through: [:favs, :pokemon]
    
    timestamps()
  end

  def create() do
    %User{token: Ecto.UUID.generate(), last_access: Ecto.DateTime.utc()}
  end
end
