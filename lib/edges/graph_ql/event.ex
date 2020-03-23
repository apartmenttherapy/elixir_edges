defmodule Edges.GraphQL.Event do
  @moduledoc """
  Holds the GraphQL object definition for an `Event` as well as the resolver functions used for `Event` related query resolution.

  ## Objects

  ### Event

  Field         | Type
  :----         | ---:
  id            | string
  action        | string
  resource_type | string
  resource_id   | string
  source        | event_source

  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Edges.Repo

  alias Edges.Events.Action

  @desc "An Event for a Source"
  object :event do
    field :id,            :id
    field :action,        :string
    field :resource_type, :string
    field :resource_id,   :string
    field :source,        :source, resolve: assoc(:source)
    field :inserted_at,   :time
  end

  @doc """
  Resolver for the newEvent GraphQL Mutation.

  ## Parameters

    - event_data: A map consisting of `source_id`, `action`, `resource_id` and `resource_type`
    - context: A map of context information, this argument is unused

  ## Examples

      iex> create(%{source_id: "04cf7fbc-9819-4cb2-9fae-8820fb7e40ac", action: "Favorited", resource_type: "Post", resource_id: "e9546fbd-260e-4f44-8073-ddd1aeee383b"})
      {:ok, %Action{}}

  """
  @spec create(%{person: String.t,
                 action: String.t,
                 resource_type: String.t,
                 resource_id: String.t}, map) :: {:ok, %Action{}} | {:error, Keyword.t}
  def create(event_data, _) do
    response = backend().create(event_data)

    case response do
      {:ok, record} ->
        {:ok, record}
      {:error, message} ->
        {:error, message: message}
    end
  end

  @doc """
  Returns as many Action records as match the Query parameters.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and or `resource_type` data

  ## Examples

      iex> list(%{source_id: "383838"}, %{})
      {:ok, [%Action{source: %Srouce{source_id: "04cf7fbc-9819-4cb2-9fae-8820fb7e40ac", id: "3834-38843-3848-2"}, action: "Viewed", resource_id: "e9546fbd-260e-4f44-8073-ddd1aeee383b", resource_type: "Listing"}]}

  """
  @spec list(map, term) :: {:ok, [%Action{}]} | {:ok, []}
  def list(event_data, _context) do
    events = backend().all(event_data)

    {:ok, events}
  end

  @doc """
  Returns a count of actions matching the query parameters.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and or `resource_type` data
    - context: a map of context related data, this is ignored

  ## Examples

      iex> count(%{source_id: "04cf7fbc-9819-4cb2-9fae-8820fb7e40ac"})
      {:ok, 10}
  """
  @spec total(map, term) :: {:ok, integer}
  def total(args, _context) do
    [count] = backend().count(args)

    {:ok, count}
  end

  @doc """
  Deletes the speicifed event from the database.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and `resource_type` data
    - context: a map of context related data, this is ignored

  ## Examples

      iex> delete(%{source_id: "04cf7fbc-9819-4cb2-9fae-8820fb7e40ac", action: "Viewed", resource_id: "e9546fbd-260e-4f44-8073-ddd1aeee383b", resource_type: "Listing"})
      {:ok, "Deleted"}

  """
  @spec delete(map, map) :: {:ok, boolean}
  def delete(event_data, _context) do
    case backend().delete(event_data) do
      {:ok, _deleted} ->
        {:ok, true}
      {:error, _reason} ->
        {:ok, false}
    end
  end

  defp backend, do: Application.get_env(:edges, :backend)
end
