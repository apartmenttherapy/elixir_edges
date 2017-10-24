defmodule Edges.GraphQL.EventTest do
  use ExUnit.Case

  alias Edges.Events.Action
  alias Edges.GraphQL.Event

  describe "creation" do
    test "create/2 returns {:ok, %Action{}} when given valid data" do
      assert {:ok, %Action{}} = Event.create(%{person: "Bob", action: "Saved", resource_type: "Story", resource_id: "8"}, [])
    end

    test "create/2 returns {:error, message: String.t} when given invalid data" do
      assert {:error, message: "Already taken"} = Event.create(%{error: "Already taken"}, [])
    end
  end

  describe "listing" do
    test "list/2 returns {:ok, [%Action{}]} when there are matches" do
      assert {:ok, [%Action{}]} = Event.list(%{person: "Bob"}, [])
    end

    test "list/2 returns {:ok, []} when there are no matches" do
      assert {:ok, []} = Event.list(%{empty: true}, [])
    end
  end

  describe "totals" do
    test "total/2 returns {:ok, integer} with the number of matching records" do
      assert {:ok, 5} = Event.total(%{value: 5}, [])
    end
  end

  describe "deletion" do
    test "delete/2 returns {:ok, true} if the event was successfully deleted" do
      assert {:ok, true} = Event.delete(%{person: "Bob"}, [])
    end

    test "delete/2 returns {:ok, false} if the event could not be deleted" do
      assert {:ok, false} = Event.delete(%{error: "Can't touch this"}, [])
    end
  end
end
