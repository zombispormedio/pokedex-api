defmodule PokedexApi.User do
  use PokedexApi.Web, :model

  schema "users" do
    field :access_token, :string
    field :last_access, Ecto.Date

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:access_token, :last_access])
    |> validate_required([:access_token, :last_access])
  end
end
