defmodule Edges.Events.ActionTest do
  use ExUnit.Case

  alias Edges.Events.Action
  alias Edges.Events.Source
  alias Edges.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edges.Repo)

    {:ok, source} =
      %Source{}
      |> Source.changeset(%{person: "4ca00341-76ec-4224-a769-ddc954232729"})
      |> Repo.insert()

    {:ok, existing_source: source}
  end

  describe "Action Creation" do
    test "creating for an existing person uses that source", %{existing_source: existing_source} do
      person = existing_source.person()
      source_id = existing_source.id()

      event = %{action: "Favorited", resource_type: "Listing", resource_id: "8b3044ca-9af6-4740-a7ef-50c670153c8b", person: person}
      {:ok, %{id: id, person: source_person} = source} = Source.find_or_create_source(event)

      assert id == source_id
      assert person == source_person

      event_with_source = Map.put(event, :source, source)

      {:ok, %{source_id: event_source_id}} =
        %Action{}
        |> Action.changeset(event_with_source)
        |> Repo.insert()

      assert source_id == event_source_id
    end

    test "creating for a new person creates a new source", %{existing_source: existing_source} do
      existing_id = existing_source.id()

      event = %{action: "Favorited", resource_type: "Listing", resource_id: "0f9b31e3-8324-4181-9deb-fb53a0251aff", person: "fb585729-0f3f-4518-868b-ea6eaeb4550b"}
      {:ok, %{id: id} = source} = Source.find_or_create_source(event)

      assert id != existing_id

      event_with_source = Map.put(event, :source, source)

      {:ok, %{source_id: event_source_id}} =
        %Action{}
        |> Action.changeset(event_with_source)
        |> Repo.insert()

      refute existing_id == event_source_id
    end
  end
end
