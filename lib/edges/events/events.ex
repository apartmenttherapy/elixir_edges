defmodule Edges.Events do
  @moduledoc """
  The boundary for the Events system.
  """

  @behaviour Edges.EventsBehaviour

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Edges.Repo

  alias Edges.Events.Action
  alias Edges.Events.Source

  @doc """
  Retrieves Source records matching the given args.

  ## Parameters

    - source_data: a map containing `:id`, or `:person` values

  ## Examples

      iex> get_sources(%{person: "383838"})
      [%Source{id: "10144-23-424-5232-38484", person: "383838"}]

  """
  @spec get_sources(map) :: [%Source{}] | []
  def get_sources(source_data) do
    base = from(r in Source)

    base
    |> where(^Map.to_list(source_data))
    |> Repo.all
  end

  @doc """
  Retrieves Action records matching the given args.

  ## Parameters

    - action_data: a map containing `:id`, `:source_id`, `:action`, `:resource_type` and or `:resource_id` pairs.

  ## Examples

      iex> get_actions(%{action: "follow"})
      [%Action{id: "1823-183-184455-5837", source_id: "2565-49673-3955-28575", action: "follow", resource_type: "Author", resource_id: "38384"}]

  """
  @spec get_actions(map) :: [%Action{}] | []
  def get_actions(action_data), do: action_data |> all()

  @doc """
  Creates a new event in the system.

  ## Parameters

    - event_data: a map containing the event data to be recorded

  ## Examples

      iex> resource = {"Author", "212484"}
      iex> create(person: "bob", action: "follow", resource_type: "Author", resource_id: "0"})
      %Action{action: "follow", resource_id: "0", resource_type: "Author", source_id: "U38DZHG"}

  """
  @spec create(map) :: {:ok, Action.t} | {:error, term}
  def create(event_data) do
    Repo.transaction(fn ->
      %Action{}
      |> Action.changeset(event_data)
      |> Repo.insert()
      |> case do
           {:ok, action} ->
             {:ok, action}
           {:error, changeset} ->
             Repo.rollback(Action.errors(changeset))
         end
    end)
  end

  @doc """
  Deletes the `Action.t` record identified by the given parameters.

  ## Parameters

    - event_data: a map of the parameters identifying the record to delete

  ## Examples

      iex> delete(%{person: "383583", action: "Favorite", resource_type: "Post", resource_id: "32358"})
      {:ok, %Action{action: "Favorite"}}

  """
  @spec delete(map) :: {:ok, Action.t} | {:error, String.t}
  def delete(event_data) do
    event_data
    |> all()
    |> case do
         [] ->
           {:error, "No such record"}
         results ->
           deleted = Enum.map(results, fn event ->
                       {:ok, record} = Repo.delete(event)

                       record
                     end)

           {:ok, deleted}
       end
  end

  @doc """
  Returns all `Action.t` records matching the given criteria.

  ## Parameters

  - query_map: a map containing the query parameters to use in the query

  ## Examples

      iex> Repo.insert %Action{action: "follow", resource_id: "238358", resource_type: "Post", source_id: "3858385uuz"}
      iex> all({:action, "follow"})
      [%Action{action: "follow", resource_id: "238358", resource_type: "Post", source_id: "3858385uuz"}]

  """
  @spec all(map) :: [Action.t]
  def all(query_map), do: query_map |> all_builder |> preload(:source) |> Repo.all()

  @doc """
  Returns the number of `Action` records matching the given criteria.

  ## Parameters

  - query_map: a map containing the parameters to use in the query

  ## Examples

      iex> count(%{action: "Click", before: Timex.now(), person: "383825"})
      [4]

  """
  @spec count(map) :: [integer]
  def count(query_map), do: query_map |> all_builder |> all_count |> Repo.all()

  defp all_builder(query_map) do
    base_query = from(a in Action)

    query_map
    |> Enum.reduce(base_query, fn part, query ->
      part
      |> all_query_part(query)
    end)
  end

  defp all_query_part({:action, action}, query) do
    from(a in query, where: a.action == ^action)
  end
  defp all_query_part({:person, person}, query) do
    from(a in query,
      join: s in Source,
      on: s.id == a.source_id,
      where: s.person == ^person)
  end
  defp all_query_part({:id, id}, query) do
    from(a in query, where: a.id == ^id)
  end
  defp all_query_part({:resource_type, resource_type}, query) do
    from(a in query, where: a.resource_type == ^resource_type)
  end
  defp all_query_part({:resource_id, resource_id}, query) do
    from(a in query, where: a.resource_id == ^resource_id)
  end
  defp all_query_part({:since, created_after}, query) do
    from(a in query, where: a.inserted_at > ^created_after)
  end
  defp all_query_part({:before, created_prior_to}, query) do
    from(a in query, where: a.inserted_at < ^created_prior_to)
  end

  defp source_join(query), do: from(a in query, join: s in Source, on: s.id == a.source_id)
  defp all_count(query), do: from(a in query, select: count(a.id))
end
