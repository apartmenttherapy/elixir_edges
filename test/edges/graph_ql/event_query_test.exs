defmodule Edges.GraphQL.EventQueryTest do
  use ExUnit.Case

  alias Edges.GraphQL.TestSchema

  @valid_create %{"action" => "created", "resourceType" => "Link", "resourceId" => "88", "person" => "Bob"}
  @error_create %{"action" => "error", "resourceType" => "Trigger", "resourceId" => "88", "person" => "Bob"}

  describe "queries" do
    test "querying events returns matches" do
      result = Absinthe.run(events_query(), TestSchema, variables: %{"id" => "8833", "action" => "Click"})

      assert {:ok, %{data: %{"events" => [%{"action" => "Click", "id" => "8833"}]}}} = result
    end

    test "querying events returns an empty list if there were no matches" do
      result = Absinthe.run(events_query(), TestSchema, variables: %{"action" => "empty"})

      assert {:ok, %{data: %{"events" => []}}} = result
    end

    test "querying the event count returns an accurate number" do
      result = Absinthe.run(count_query(), TestSchema, variables: %{"action" => "8"})

      assert {:ok, %{data: %{"eventCount" => "8"}}} = result
    end

    def events_query do
      """
      query events($id: ID, $action: String) {
        events(id: $id, action: $action) {
          id
          action
        }
      }
      """
    end

    def count_query do
      """
      query eventCount($action: String) {
        eventCount(action: $action)
      }
      """
    end
  end

  describe "mutations" do
    test "creating an event returns the event when successful" do
      result = Absinthe.run(create_query(), TestSchema, variables: @valid_create)
      create_attrs = Map.delete(@valid_create, "person")

      assert {:ok, %{data: %{"newEvent" => ^create_attrs}}} = result
    end

    test "creating an event returns a useful error when it fails" do
      result = Absinthe.run(create_query(), TestSchema, variables: @error_create)

      assert {:ok, %{data: %{"newEvent" => nil}, errors: [%{locations: _, message: "In field \"newEvent\": Failed to create Event"}]}} = result
    end

    test "deleting an event returns true if successful" do
      result = Absinthe.run(delete_query(), TestSchema, variables: @valid_create)

      assert {:ok, %{data: %{"deleteEvent" => true}}} = result
    end

    test "deleting an event returns false if unsuccessful" do
      result = Absinthe.run(delete_query(), TestSchema, variables: %{@valid_create | "action" => "error"})

      assert {:ok, %{data: %{"deleteEvent" => false}}} = result
    end

    def create_query do
      """
      mutation newEvent($action: String!, $resourceType: String!, $resourceId: String!, $person: String!) {
        newEvent(action: $action, resourceType: $resourceType, resourceId: $resourceId, person: $person) {
          action
          resourceType
          resourceId
        }
      }
      """
    end

    def delete_query do
      """
      mutation deleteEvent($person: String!, $action: String!, $resourceType: String!, $resourceId: String!) {
        deleteEvent(person: $person, action: $action, resourceType: $resourceType, resourceId: $resourceId)
      }
      """
    end
  end
end
