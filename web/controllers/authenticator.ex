defmodule PokedexApi.Authenticator do
    use PokedexApi.Web, :controller

    alias PokedexApi.User
    
    def resolve(conn) do
        auth = (get_req_header(conn, "authorization") |> List.first)
        cond do
            auth != nil-> get_user(auth)
            true -> Repo.insert!(User.create())
        end
    end
    
    def get_user(token) do
        user =  get_valid_user(token)
        cond do
            user != nil -> user
            true -> Repo.insert!(User.create())
        end
    end
    
    def get_valid_user(token) do
        case Ecto.UUID.cast(token) do
            {:ok, t} -> Repo.one(from u in User, where: u.token == ^t)
            :error -> Repo.insert!(User.create())
        end
    end

end