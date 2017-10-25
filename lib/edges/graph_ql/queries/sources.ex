defmodule Edges.GraphQL.Queries.Sources do
  use Absinthe.Schema.Notation

  alias Edges.GraphQL.Source

  object :sources_queries do
    field :source, :source do
      arg :id,     :id
      arg :person, :string

      resolve &Source.fetch/2
    end
  end
end
