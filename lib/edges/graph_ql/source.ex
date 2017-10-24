defmodule Edges.GraphQL.Source do
  @moduledoc """
  Holds the GraphQL object definition and resolver functions for `Source`s.

  ## Objects

  ### source

  Field        | Type
  :----        | ---:
  id           | string
  source_id    | string
  actions      | list_of(action)

  ### event_source

  Field        | Type
  :----        | ---:
  id           | string
  source_id    | string

  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Edges.Repo

  alias Edges.Events
  alias Edges.Events.Source

  @desc "A Source (They whom smelt it)"
  object :source do
    field :id,           :string
    field :person,       :string
    field :events,       list_of(:event), resolve: assoc(:actions)
  end

  @doc """
  Returns all `Edges.Events.User` records matching the given criteria.

  ## Parameters

    - source_attributes: A map containing `source_id` and `id` values
    - context: required by Absinthe, this argument is unused in this function

  ## Examples

      iex> fetch(%{source_id: "84835"})
      {:ok, [%User{source_id: "84835", id: "2383-1384-18448-1843758"}]}

  """
  @spec fetch(%{source_id: String.t,
                id: String.t}, map) :: {:ok, [%Source{}]} | {:ok, []}
  def fetch(source_attributes, _context) do
    {:ok, Events.get_sources(source_attributes)}
  end
end
