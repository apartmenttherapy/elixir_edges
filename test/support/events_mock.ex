defmodule Edges.Events.Mock do
  @behaviour Edges.EventsBehaviour

  alias Edges.Events.Action
  alias Edges.Events.Source

  def get_actions(%{empty: true}), do: []
  def get_actions(attrs), do: [struct(Action, attrs)]

  def get_sources(%{person: "Fake Person"}), do: []
  def get_sources(attrs), do: [struct(Source, attrs)]

  def create(%{error: message}), do: {:error, message}
  def create(_attrs), do: {:ok, %Action{}}

  def delete(%{error: message}), do: {:error, message}
  def delete(_attrs), do: {:ok, %Action{}}

  def all(%{empty: true}), do: []
  def all(_attrs), do: [%Action{}]

  def count(%{value: value}), do: [value]
end
