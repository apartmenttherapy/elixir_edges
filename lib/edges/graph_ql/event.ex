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

  import Ecto.Query

  alias Edges.Repo
  alias Edges.Events
  alias Edges.Events.Action

  scalar :edge_time, description: "ISOz time since Unix Epoch" do
    parse &Timex.parse(&1.value, "{s-epoch}")
    serialize &Timex.format!(&1, "{s-epoch}")
  end

  @desc "An Event for a Source"
  object :event do
    field :id,            :string
    field :action,        :string
    field :resource_type, :string
    field :resource_id,   :string
    field :source,        :event_source
    field :inserted_at,   :time
  end

  @doc """
  Resolver for the newEvent GraphQL Mutation.

  ## Parameters

    - event_data: A map consisting of `source_id`, `action`, `resource_id` and `resource_type`
    - context: A map of context information, this argument is unused

  ## Examples

      iex> create(%{source_id: "383838", action: "favorite", resource_type: "Post", resource_id: "223854"})
      {:ok, %Action{}}

  """
  @spec create(%{person: String.t,
                 action: String.t,
                 resource_type: String.t,
                 resource_id: String.t}, map) :: {:ok, %Action{}} | {:error, String.t}
  def create(event_data, _) do
    Events.create(event_data)
  end

  @doc """
  Returns as many Action records as match the Query parameters.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and or `resource_type` data

  ## Examples

      iex> list(%{source_id: "383838"}, %{})
      {:ok, [%Action{source: %Srouce{source_id: "383838", id: "3834-38843-3848-2"}, action: "follow", resource_id: "857", resource_type: "Author"}]}

  """
  @spec list(map, term) :: {:ok, [%Action{}]} | {:ok, []}
  def list(event_data, _context) do
    events = Events.all(event_data)

    {:ok, events}
  end

  @doc """
  Returns a count of actions matching the query parameters.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and or `resource_type` data
    - context: a map of context related data, this is ignored

  ## Examples

      iex> count(%{source_id: "383838"})
      {:ok, 10}
  """
  @spec total(map, term) :: {:ok, integer}
  def total(args, _context) do
    [count] = Events.count(args)

    {:ok, count}
  end

  @doc """
  Deletes the speicifed event from the database.

  ## Parameters

    - event_data: a map of `source_id`, `action`, `resource_id` and `resource_type` data
    - context: a map of context related data, this is ignored

  ## Examples

      iex> delete(%{source_id: "38385", action: "read", resource_id: "38382", resource_type: "Post"})
      {:ok, "Deleted"}

  """
  @spec delete(map, map) :: {:ok, boolean}
  def delete(event_data, _context) do
    case Events.delete(event_data) do
      {:ok, _deleted} ->
        {:ok, true}
      {:error, _reason} ->
        {:ok, false}
    end
  end
end
