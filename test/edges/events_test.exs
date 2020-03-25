defmodule Edges.EventsTest do
  use ExUnit.Case
  use Timex

  alias Edges.Repo

  alias Edges.Events
  alias Edges.Events.Action
  alias Edges.Events.Source

  @source "4ca00341-76ec-4224-a769-ddc954232729"
  @alien_source "366cb1dd-0be7-4faa-8a07-c2844e7933bc"
  @valid_event %{person: @source, action: "Favorited", resource_type: "Store", resource_id: "e5dfe887-5ca4-4bb2-8fb6-7d71c3b9ed8d"}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edges.Repo)

    single_event = fn ->
      event_with_source = Map.put(@valid_event, :source, Source.find_or_create_source(@valid_event))

      {:ok, event} =
        %Action{}
        |> Action.changeset(event_with_source)
        |> Repo.insert()

      event
    end

    two_events = fn ->
      new_event = Enum.into(%{action: "Viewed", resource_id: "e5dfe887-5ca4-4bb2-8fb6-7d71c3b9ed8d"}, @valid_event)
      event_with_source = Map.put(new_event, :source, Source.find_or_create_source(new_event))

      {:ok, second} =
        %Action{}
        |> Action.changeset(event_with_source)
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
      expected_result = single_event.()
      result = Events.get_actions(%{resource_type: "Store"})
      assert [expected_result] == result
    end

    test "get_actions/1 returns all actions for a specific resource id", %{single_event: single_event} do
      expected_result = single_event.()
      result = Events.get_actions(%{resource_id: "e5dfe887-5ca4-4bb2-8fb6-7d71c3b9ed8d"})
      assert [expected_result] == result
    end

    test "get_actions/1 returns all actions for a specific id", %{single_event: single_event} do
      expected_result = single_event.()
      result = Events.get_actions(%{id: expected_result.id()})
      assert [expected_result] == result
    end

    test "get_actions/1 returns actions for the given source", %{single_event: single_event} do
      expected_result = single_event.()
      result = Events.get_actions(%{person: @source})
      assert [expected_result] == result
    end

    test "get_actions/1 returns an empty list if there are no matches" do
      assert [] == Events.get_actions(%{resource_type: "Not a resource"})
    end
  end

  describe "source retrieval" do
    test "get_sources/1 returns all matching sources", %{source: alien} do
      expected_result = alien.()
      result = Events.get_sources(%{person: @alien_source})
      assert [expected_result] == result
    end

    test "get_sources/1 returns an empty list if there are no matches" do
      assert [] == Events.get_sources(%{person: "Nobody"})
    end
  end

  describe "event count" do
    test "count/1 returns the count of all actions when given an empty map", %{two_events: events} do
      events.()
      expected_result = Enum.count(Repo.all(Action))
      result = Events.count(%{})
      assert [expected_result] == result
    end

    test "count/1 returns the count of actions that match the params", %{two_events: events} do
      events.()
      result = Events.count(%{action: "Favorited"})
      assert [1] == result
    end
  end

  describe "event deletion" do
    test "delete/1 deletes the action matching the given parameters", %{two_events: events} do
      events.()
      {result_status, message} = Events.delete(%{action: "Favorited"})
      assert :ok == result_status
      assert is_list(message)
    end

    test "delete/1 deletes all actions matching the parameters if there are multiple", %{single_event: human_event} do
      human_event.()
      Events.delete(%{person: @source})
      result = Enum.count(Repo.all(Action))
      assert 0 == result
    end
  end

  describe "check field validation" do
    test "create/2 return error because incorrect action" do
      event_data = Enum.into(%{action: "-1 OR 3*2>(0+5+257-257)"}, @valid_event)
      result = Events.create(event_data)
      assert {:error, %{message: ["Incorrect value for field action"]}} == result
    end

    test "create/2 return error because incorrect resource_type" do
      event_data = Enum.into(%{resource_type: "(select(0)from(select(sleep(2)))v)/*'+(select(0)from(select(sleep(3)))v)+'", resource_id: "e5dfe887-5ca4-4bb2-8fb6-7d71c3b9ed8d"}, @valid_event)
      result = Events.create(event_data)
      assert {:error, %{message: ["Incorrect value for field resource_type"]}} == result
    end
  end
end
