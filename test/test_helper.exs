ExUnit.start()

Edges.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Edges.Repo, :manual)
