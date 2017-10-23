defmodule Edges.EventsTest do
  use ExUnit.Case
  use Timex

  alias Edges.Repo

  alias Edges.Events
  alias Edges.Events.Action
  alias Edges.Events.Source

  import Ecto.Query

  @source "Human"
  @alien_source "Alien"
  @valid_event %{person: @source, action: "Did stuff", resource_type: "History", resource_id: "1978"}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edges.Repo)

    single_event = fn ->
      {:ok, event} =
        %Action{}
        |> Action.changeset(@valid_event)
        |> Repo.insert()

      event
    end

    two_events = fn ->
      {:ok, second} =
        %Action{}
        |> Action.changeset(Enum.into(%{action: "Died", resource_id: "1980"}, @valid_event))
        |> Repo.insert()

      [single_event.(), second]
    end

    isolated_source = fn ->
      {:ok, source} =
        %Source{}
        |> Source.changeset(%{person: @alien_source})
        |> Repo.insert()

      source
    end

    {:ok, single_event: single_event, two_events: two_events, source: isolated_source}
  end

  describe "event retrieval" do
    test "get_actions/1 returns all actions for a 'History' record", %{single_event: single_event} do
      event = single_event.()

      assert [^event] = Events.get_actions(%{resource_type: "History"})
    end

    test "get_actions/1 returns all actions for a specific resource id", %{single_event: single_event} do
      event = single_event.()

      assert [^event] = Events.get_actions(%{resource_id: "1978"})
    end

    test "get_actions/1 returns all actions for a specific id", %{single_event: single_event} do
      event = single_event.()

      assert [^event] = Events.get_actions(%{id: event.id()})
    end

    test "get_actions/1 returns actions for the given source", %{single_event: single_event} do
      event = single_event.()

      assert [^event] = Events.get_actions(%{person: @source})
    end

    test "get_actions/1 returns an empty list if there are no matches" do
      assert [] = Events.get_actions(%{resource_type: "Not a resource"})
    end
  end

  describe "source retrieval" do
    test "get_sources/1 returns all matching sources", %{source: alien} do
      source = alien.()

      assert [^source] = Events.get_sources(%{person: @alien_source})
    end

    test "get_sources/1 returns an empty list if there are no matches" do
      assert [] = Events.get_sources(%{person: "Nobody"})
    end
  end

  describe "event count" do
    test "count/1 returns the count of all actions when given an empty map", %{two_events: events} do
      events.()
      total = Enum.count(Repo.all(Action))

      assert [^total] = Events.count(%{})
    end

    test "count/1 returns the count of actions that match the params", %{two_events: events} do
      events.()

      assert [1] = Events.count(%{action: "Died"})
    end
  end

  describe "event deletion" do
    test "delete/1 deletes the action matching the given parameters", %{two_events: events} do
      events.()

      assert {:ok, [%Action{}]} = Events.delete(%{action: "Died"})
    end

    test "delete/1 deletes all actions matching the parameters if there are multiple", %{single_event: human_event} do
      human_event.()
      Events.delete(%{person: @source})

      assert 0 = Enum.count(Repo.all(Action))
    end
  end
end
