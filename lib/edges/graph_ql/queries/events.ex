defmodule Edges.GraphQL.Queries.Events do
  use Absinthe.Schema.Notation

  alias Edges.GraphQL.Event

  object :events_queries do
    field :events, list_of(:event) do
      arg :id,            :id
      arg :action,        :string
      arg :resource_type, :string
      arg :resource_id,   :string
      arg :person,        :string

      resolve &Event.list/2
    end

    field :event_count, :integer do
      arg :action,        :string
      arg :resource_type, :string
      arg :resource_id,   :string
      arg :person,        :string

      resolve &Event.total/2
    end
  end

  object :events_mutations do
    field :new_event, :event do
      arg :action,        non_null(:string)
      arg :resource_type, non_null(:string)
      arg :resource_id,   non_null(:string)
      arg :person,        non_null(:string)

      resolve &Event.create/2
    end

    field :delete_event, :boolean do
      arg :person,        non_null(:string)
      arg :action,        non_null(:string)
      arg :resource_type, non_null(:string)
      arg :resource_id,   non_null(:string)

      resolve &Event.delete/2
    end
  end
end
