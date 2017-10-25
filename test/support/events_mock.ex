defmodule Edges.Events.Mock do
  @behaviour Edges.EventsBehaviour

  alias Edges.Events.Action
  alias Edges.Events.Source

  def get_sources(%{person: "Fake Person"}), do: []
  def get_sources(attrs), do: [struct(Source, attrs)]

  def create(%{error: message}), do: {:error, message}
  def create(attrs), do: {:ok, %Action{}}

  def delete(%{error: message}), do: {:error, message}
  def delete(attrs), do: {:ok, %Action{}}

  def all(%{empty: true}), do: []
  def all(attrs), do: [%Action{}]

  def count(%{value: value}), do: [value]
end
