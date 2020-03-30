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
  import Ecto.Query, warn: false

  alias Edges.Events.Action
  alias Ecto.UUID
  alias Edges.Repo
  alias __MODULE__

  @auth0_validate_reg_exp ~r/^(auth0|google-oauth2|facebook)\|[a-zA-Z0-9]+/

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
    |> validate_change(:person, fn(:person, attrs) -> is_person(:person, attrs) end)
  end

  @spec is_person(atom(), String.t()) :: List.t()
  defp is_person(key, value) do
    value
    |> UUID.cast()
    |> is_auth0(key, value)
  end

  @spec is_auth0(tuple(), atom(), String.t()) :: List.t()
  defp is_auth0({:ok, _}, _key, _value), do: []
  defp is_auth0(_, key, value) do
    with [user_id] <- String.split(value),
         true <- user_id == value,
         true <- Regex.match?(@auth0_validate_reg_exp, value) do
      []
    else
      _-> [{key, "Incorrect value for field "<> Atom.to_string(key)}]
    end
  end

  @spec find_or_create_source(map) :: List.t()
  def find_or_create_source(%{person: person}) do
    from(s in Source, where: s.person == ^person)
    |> Repo.one()
    |> maybe_insert_person(person)
  end

  defp maybe_insert_person(nil, person) do
    %Edges.Events.Source{}
    |> Source.changeset(%{person: person})
    |> Repo.insert
  end
  defp maybe_insert_person(res, _), do: {:ok, res}

end
