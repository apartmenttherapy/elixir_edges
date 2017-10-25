defmodule Edges.Events.Source do
  @moduledoc """
  This represents a `Reader` of the site.

  ## Table

  Column       | Type                        | Nullable             | Default
  :-----       | :--:                        | :------:             | ------:
  id           | uuid                        |  false               | NULL
  person       | string                      |  false               | NULL
  inserted_at  | timestamp without time zone |  false               | NULL
  updated_at   | timestamp without time zone |  false               | NULL

  ## Associations

  ### Has Many

    * actions: ReaderEvents.Events.Action

  ## Indices

    * person: unique index

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Edges.Events.Action

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sources" do
    field :person, :string

    has_many :actions, Action

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = source, attrs) do
    source
    |> cast(attrs, [:person])
  end
end
