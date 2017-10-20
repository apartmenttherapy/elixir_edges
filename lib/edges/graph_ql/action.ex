defmodule Edges.GraphQL.Action do
  @moduledoc """
  Holds the GraphQL object definition and resolver functions for `Action`s

  ## Objects

  ### action

  Field         | Type
  :----         | ---:
  id            | string
  action        | string
  resource_type | string
  resource_id   | string
  reader_id     | string

  ### event_action

  Field         | Type
  :----         | ---:
  id            | string
  action        | string
  resource_type | string
  resource_id   | string

  """

  use Absinthe.Schema.Notation

  alias Edges.Events
  alias Edges.Events.Action

  @desc "An Action taken by a user on a Site Resource"
  object :action do
    field :id,            :string
    field :action,        :string
    field :resource_type, :string
    field :resource_id,   :string
    field :reader_id,     :string
  end

  @desc "The Action belonging to a specific Event"
  object :event_action do
    field :id,            :string
    field :action,        :string
    field :resource_type, :string
    field :resource_id,   :string
  end

  @doc """
  Returns all `ReaderEvents.Events.Action` records macthing the given criteria.

  ## Parameters

    - action_data: A map of `id`, `reader_id`, `action`, `resource_type` and or `resource_id` values
    - context: This is required by Absinthe, it is unused by the function

  ## Examples

      iex> all(%{action: "snoozed"})
      {:ok, [%Action{id: "3838t-48665-18223-111", action: "snoozed", reader_id: "38321-131-48384-18448", resource_type: "Post", resource_id: "38522"}]}

  """
  @spec all(map, map) :: {:ok, [%Action{}]} | {:ok, []}
  def all(action_data, _context) do
    {:ok, Events.get_actions(action_data)}
  end
end
