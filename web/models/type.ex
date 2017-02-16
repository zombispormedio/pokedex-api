defmodule PokedexApi.Type do
  use PokedexApi.Web, :model

   alias PokedexApi.Pokemon

  schema "types" do
    field :name, :string
    has_many :pokemons, Pokemon

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
