defmodule Edges.GraphQL.Source do
  @moduledoc """
  Holds the GraphQL object definition and resolver functions for `Source`s.

  ## Objects

  ### source

  Field        | Type
  :----        | ---:
  id           | string
  person       | string
  actions      | list_of(action)

  ### event_source

  Field        | Type
  :----        | ---:
  id           | string
  person       | string

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
  Returns all `Edges.Events.Source` records matching the given criteria.

  ## Parameters

    - source_attributes: A map containing `source_id` and `id` values
    - context: required by Absinthe, this argument is unused in this function

  ## Examples

      iex> fetch(%{person: "bob"})
      {:ok, [%User{person: "bob", id: "2383-1384-18448-1843758"}]}

  """
  @spec fetch(%{person: String.t,
                id: String.t}, map) :: {:ok, [%Source{}]} | {:ok, []}
  def fetch(source_attributes, _context) do
    {:ok, backend().get_sources(source_attributes)}
  end

  defp backend, do: Application.get_env(:edges, :backend)
end
