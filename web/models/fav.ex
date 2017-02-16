defmodule PokedexApi.Fav do
  use PokedexApi.Web, :model

  alias PokedexApi.User
  alias PokedexApi.Pokemon

  schema "favs" do
    belongs_to :user, User
    belongs_to :pokemon, Pokemon

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
