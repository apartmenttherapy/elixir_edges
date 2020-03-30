defmodule Edges.GraphQL.SourceQueryTest do
  use ExUnit.Case

  alias Edges.GraphQL.TestSchema

  describe "queries" do
    test "querying for an existing source by id returns matches" do
      result = Absinthe.run(source_query(), TestSchema, variables: %{"id" => "exists"})

      assert {:ok, %{data: %{"source" => %{"id" => "exists", "person" => nil}}}} == result
    end

    test "querying for an existing source by person returns matches" do
      result = Absinthe.run(source_query(), TestSchema, variables: %{"person" => "Bob"})

      assert {:ok, %{data: %{"source" => %{"id" => nil, "person" => "Bob"}}}} == result
    end

    test "querying for a non-existant source returns a sane error" do
      result = Absinthe.run(source_query(), TestSchema, variables: %{"person" => "Fake Person"})

      assert {:ok, %{data: %{"source" => nil}}} == result
    end

    def source_query do
      """
      query source($id: ID, $person: String) {
        source(id: $id, person: $person) {
          id
          person
        }
      }
      """
    end
  end
end
