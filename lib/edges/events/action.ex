defmodule Edges.Events.Action do
  @moduledoc """
  This represents an `Action` taken by a Edges.Events.Source on the site.

  ## Table

  Column        | Type                        | Nullable | Default
  :-----        | :--:                        | :------: | ------:
  id            | uuid                        |  false   | NULL
  source_id     | uuid                        |  false   | NULL
  action        | citext                      |  true    | NULL
  resource_type | varchar(255)                |  true    | NULL
  resource_id   | varchar(255)                |  true    | NULL
  inserted_at   | timestamp without time zone |  false   | NULL
  updated_at    | timestamp without time zone |  false   | NULL

  ## Associations

  ### Belongs To

    * source: each action belongs to a single Edges.Events.Source record

  ## Indices

    * actions_action_index: index on the action field

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Edges.Events.Source
  alias Edges.Repo

  @type t :: %Action{id: String.t,
                     source_id: String.t,
                     action: String.t,
                     resource_type: String.t,
                     resource_id: String.t,
                     inserted_at: DateTime.t,
                     updated_at: DateTime.t}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "actions" do
    field :action,        :string
    field :resource_id,   :string
    field :resource_type, :string

    belongs_to :source, Source

    timestamps()
  end

  @doc false
  def changeset(%Action{} = action, attrs) do
    action
    |> cast(attrs, [:action, :resource_type, :resource_id])
    |> put_assoc(:source, find_or_create_source(attrs))
    |> validate_required([:action, :resource_type, :resource_id, :source])
  end

  defp find_or_create_source(attrs) do
    person =
      attrs
      |> Map.get(:person)

    Repo.one(Source, person: person) ||
      Repo.insert!(%Source{person: person})
  end

  @doc """
  Extracts changeset errors and formats them as a keyword list.

  ## Parameters

    - changeset: A ReaderEvents.Events.Action Changeset

  ## Examples

      iex> errors(%Ecto.Changeset{action: :insert, changes: %{action: "saved"}, constraints: [], data: %Action{}, errors: [{:saved, "not unique"}]})
      %{message: [saved: "not unique"]}

  """
  @spec errors(Ecto.Changeset.t) :: %{message: list}
  def errors(changeset) do
    messages =
      changeset
      |> Map.get(:errors)
      |> Enum.reduce([], fn {_name, {message, _jumk}}, acc ->
           [message] ++ acc
         end)

      %{message: messages}
  end
end
