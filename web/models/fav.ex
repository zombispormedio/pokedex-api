defmodule PokedexApi.Fav do
  use PokedexApi.Web, :model

  alias PokedexApi.User
  alias PokedexApi.Pokemon

  schema "favs" do
    belongs_to :user, User
    belongs_to :pokemon, Pokemon

    timestamps()
  end
  
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :pokemon_id])
    |> validate_required([:user_id, :pokemon_id])
    |> foreign_key_constraint(:user_id)
    |> assoc_constraint(:user)
    |> foreign_key_constraint(:pokemon_id)
    |> assoc_constraint(:pokemon)
  end
end
