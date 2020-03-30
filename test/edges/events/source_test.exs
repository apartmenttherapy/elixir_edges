defmodule Edges.Events.SourceTest do
  use ExUnit.Case

  alias Edges.Events.Source
  alias Edges.Events

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edges.Repo)
  end

  describe "Source credentials" do
    test "creating source for person with auth0 id" do
      event = %{person: "auth0|1234"}
      {:ok, %{id: id, person: person}} = Source.find_or_create_source(event)

      [%Source{person: source_person, id: source_id}] = Events.get_sources(event)

      assert source_person == person
      assert source_id == id
    end

    test "creating source for person with facebook id" do
      event = %{person: "facebook|1234"}
      {:ok, %{id: id, person: person}} = Source.find_or_create_source(event)

      [%Source{person: source_person, id: source_id}] = Events.get_sources(event)

      assert source_person == person
      assert source_id == id
    end

    test "creating source for person with google-oauth2 id" do
      event = %{person: "google-oauth2|1234"}
      {:ok, %{id: id, person: person}} = Source.find_or_create_source(event)

      [%Source{person: source_person, id: source_id}] = Events.get_sources(event)

      assert source_person == person
      assert source_id == id
    end

    @tag runnable: true
    test "can not create source for incorrect person id" do
      event = %{person: "google-oauth2|1234 || '(select(0)from(select(sleep(2)))v)/*'+(select(0)from(select(sleep(3)))v)+'"}
      {status, _} = Source.find_or_create_source(event)
      assert :error == status

      sources = Events.get_sources(event)

      assert [] == sources
    end
  end
end
