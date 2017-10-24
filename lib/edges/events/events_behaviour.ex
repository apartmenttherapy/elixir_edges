defmodule Edges.EventsBehaviour do
  alias Edges.Events.Action
  alias Edges.Events.Source

  @callback get_sources(attrs :: map()) :: [Source.t]
  @callback get_actions(attrs :: map()) :: [Action.t]
  @callback create(attrs :: map()) :: {:ok, Action.t} | {:error, term}
  @callback delete(attrs :: map()) :: {:ok, Action.t} | {:error, String.t}
  @callback all(attrs :: map()) :: [Action.t]
  @callback count(attrs :: map()) :: [integer]
end
