defmodule Edges.GraphQL.TestSchema do
  use Absinthe.Schema

  alias Edges.GraphQL.Event
  alias Edges.GraphQL.Source

  alias Edges.GraphQL.Types.Time
  alias Edges.GraphQL.Queries.Events
  alias Edges.GraphQL.Queries.Sources

  import_types Event
  import_types Events
  import_types Source
  import_types Sources
  import_types Time

  query do
    import_fields :events_queries
    import_fields :sources_queries
  end

  mutation do
    import_fields :events_mutations
  end
end
