defmodule Edges.GraphQL.Queries.Users do
  use Absinthe.Schema.Notation

  alias Edges.GraphQL.User

  object :users_queries do
    field :users, list_of(:user) do
      arg :id,           :string
      arg :user_id,      :string

      resolve &User.fetch/2
    end
  end
end
