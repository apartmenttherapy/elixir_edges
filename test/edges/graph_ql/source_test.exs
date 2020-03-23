defmodule Edges.GraphQL.SourceTest do
  use ExUnit.Case

  alias Edges.GraphQL.Source
  alias Edges.Events.Source, as: SourceRecord

  describe "fetching" do
    test "fetch/2 returns {:ok, [Source.t]} when there is a match" do
      {result_status, result} = Source.fetch(%{person: "Bob"}, [])
      assert :ok == result_status
      assert %SourceRecord{person: "Bob"} == result
    end

    test "fetch/2 returns {:ok, []} when there are no matches" do
      assert {:ok, nil} == Source.fetch(%{person: "Fake Person"}, [])
    end
  end
end
