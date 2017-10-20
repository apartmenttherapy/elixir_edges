defmodule Edges.GraphQL.Queries.Actions do
  use Absinthe.Schema.Notation

  alias Edges.GraphQL.Action

  object :actions_queries do
    field :actions, list_of(:action) do
      arg :id,            :string
      arg :reader_id,     :string
      arg :action,        :string
      arg :resource_type, :string
      arg :resource_id,   :string

      resolve &Action.all/2
    end
  end
end
