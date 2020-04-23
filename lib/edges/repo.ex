defmodule Edges.Repo do
  use Ecto.Repo,
      otp_app: :edges,
      adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    config = Keyword.put(opts, :url, database_url())

    {:ok, config}
  end

  defp database_url do
    case System.get_env("EDGES_DATABASE_URL") do
      nil ->
        System.get_env("DATABASE_URL")
      url ->
        url
    end
  end
end
