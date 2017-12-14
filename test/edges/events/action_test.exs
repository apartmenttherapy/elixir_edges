defmodule Edges.Events.ActionTest do
  use ExUnit.Case

  alias Edges.Events.Action
  alias Edges.Events.Source
  alias Edges.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edges.Repo)

    {:ok, source} =
      %Source{}
      |> Source.changeset(%{person: "test source"})
      |> Repo.insert()

    {:ok, existing_source: source}
  end

  describe "Action Creation" do
    test "creating for an existing person uses that source", %{existing_source: source} do
      person = source.person()
      source_id = source.id()

      {:ok, action} =
        %Action{}
        |> Action.changeset(%{action: "Favorited", resource_type: "Listing", resource_id: "42", person: person})
        |> Repo.insert()

      assert ^source_id = action.source_id()
    end

    test "creating for a new person creates a new source", %{existing_source: source} do
      existing_id = source.id()

      {:ok, action} =
        %Action{}
        |> Action.changeset(%{action: "Favorites", resource_type: "Listing", resource_id: "42", person: "new guy"})
        |> Repo.insert()

      refute existing_id == action.source_id()
    end
  end
end
