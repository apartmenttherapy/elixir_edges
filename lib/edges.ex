defmodule Edges do
  @moduledoc """
  Documentation for Edges.
  """

  use Application

  alias Edges.Repo

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Edges.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
