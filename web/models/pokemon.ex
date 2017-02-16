defmodule PokedexApi.Pokemon do
  use PokedexApi.Web, :model

  alias PokedexApi.Type
  alias PokedexApi.Fav
  alias PokedexApi.Pokemon


  schema "pokemons" do
    field :name, :string
    field :description, :string
    field :evolution, :string
    belongs_to :type1, Type
    belongs_to :type2, Type

    has_many :favs, Fav

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    Map.merge(struct, %Pokemon{type1_id: struct.type1, type2_id: struct.type2})
    |> cast(params, [:name, :description, :evolution, :type2_id, :type1_id])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 4, max: 24, message: "Nombre debe tener de 4 a 24 caracteres")
    |> validate_length(:description, min: 30,  message: "Descripción debe tener un mínimo de 30 caracteres")
    |> validate_format(:name, ~r/^[A-Za-z]+$/, message: "Nombre debe ser sólo una palabra")
    |> unique_constraint(:name, message: "Nombre debe ser único")
    |> foreign_key_constraint(:type1_id, message: "Debe ser un tipo válido")
    |> foreign_key_constraint(:type2_id, message: "Debe ser un tipo válido")
    |> types_not_equals
  end

  defp types_not_equals(changeset) do
    type1 = get_field(changeset, :type1_id)
    type2 = get_field(changeset, :type2_id)

    cond do
      type1==type2 -> 
        changeset
        |> add_error([:type1_id, :type2_id], message: "Tipos no deben ser iguales")
      true -> changeset
    end

  end
end
