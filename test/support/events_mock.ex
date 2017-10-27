defmodule Edges.Events.Mock do
  @behaviour Edges.EventsBehaviour

  alias Edges.Events.Action
  alias Edges.Events.Source

  def get_actions(%{action: "empty"}), do: []
  def get_actions(attrs), do: [struct(Action, attrs)]

  def get_sources(%{person: "Fake Person"}), do: []
  def get_sources(attrs), do: [struct(Source, attrs)]

  def create(%{action: "error"}), do: {:error, "Failed to create Event"}
  def create(attrs) do
    action =
      attrs
      |> Map.delete(:person)

    {:ok, struct(Action, action)}
  end

  def delete(%{action: "error"}), do: {:error, "Failed to delete record"}
  def delete(_attrs), do: {:ok, %Action{}}

  def all(%{action: "empty"}), do: []
  def all(attrs), do: [struct(Action, attrs)]

  def count(%{action: value}), do: [value]
  def count(%{value: value}), do: [value]
end
