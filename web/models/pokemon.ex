defmodule PokedexApi.Pokemon do
  use PokedexApi.Web, :model

  alias PokedexApi.Type
  alias PokedexApi.Fav
  alias PokedexApi.PokeApi

  schema "pokemons" do
    field :name, :string
    field :description, :string
    field :evolution, :string
    field :sprite, :string
    belongs_to :type1, Type, foreign_key: :type1_id
    belongs_to :type2, Type, foreign_key: :type2_id
    has_many :favs, Fav

    timestamps()
  end

  def paginate(params) do
    per_pages= 20
    case Map.has_key?(params, "p") do
      true ->
        page = String.to_integer(params["p"])
        offset = (page-1) * per_pages
        %{limit: per_pages, offset: offset, page: page}
      _ ->  %{limit: per_pages, offset: 0, page: 1}
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}, types) do
    params = (parse_types(params) |> empty_sprite)
    struct
    |> cast(params, [:name, :description, :evolution, :type1_id, :type2_id, :sprite])
    |> validate_required([:name, :description, :type1_id])
    |> validate_length(:name, min: 4, max: 24, message: "Debe tener de 4 a 24 caracteres")
    |> validate_length(:description, min: 30,  message: "Debe tener un mínimo de 30 caracteres")
    |> validate_format(:name, ~r/^[A-Za-z]+$/, message: "Nombre debe ser sólo una palabra")
    |> unique_constraint(:name, message: "debe ser único")
    |> foreign_key_constraint(:type1_id)
    |> assoc_constraint(:type1)
    |> validate_inclusion_types(types)
    |> types_not_equals
    |> add_sprite(struct)
  end

  defp types_not_equals(changeset) do
    type1 = get_field(changeset, :type1_id)
    type2 = get_field(changeset, :type2_id)
    cond do
      type1==type2 -> add_error(changeset, :type, "no deben ser iguales")
      true -> changeset
    end
  end

  defp add_sprite(changeset, struct) do
     name = get_field(changeset, :name)
    cond do
      name != nil  and (struct.name != name or struct.sprite == nil)  -> 
        sprite = PokeApi.sprite(name)
        change(changeset, %{sprite: sprite})
      true -> changeset
    end
  end

  defp validate_inclusion_types(changeset, types) do
    Enum.reduce([:type1_id, :type2_id], changeset, fn key, memo ->
      if get_field(memo, key) != nil, do: validate_inclusion(memo, key, types), else: memo
    end)
  end

  defp parse_types(params) do
    cond do
      has_all_types(params) ->
        params = Map.put(params, "type1_id", params["type1"])
        type2 = params["type2"]
        if type2 > 0, do: Map.put(params, "type2_id", type2), else: params
      has_one_type(params) ->  Map.put(params, "type1_id", params["type1"])
      true -> params
    end
  end

  defp empty_sprite(params) do
    Map.put(params, "sprite", "")
  end

  defp has_all_types(params) do
    Map.has_key?(params, "type1")  and  Map.has_key?(params, "type2")
  end
  defp has_one_type(params) do
    Map.has_key?(params, "type1")
  end
end
