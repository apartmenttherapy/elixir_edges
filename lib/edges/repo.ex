defmodule Edges.Repo do
  use Ecto.Repo, otp_app: :edges

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    config =
      opts
      |> Keyword.put(:url, database_url())
      |> Keyword.put(:pool_size, pool_size())

    {:ok, config}
  end

  defp pool_size, do: System.get_env("POOL_SIZE") || "10"

  defp database_url do
    case System.get_env("EDGES_DATABASE_URL") do
      nil ->
        System.get_env("DATABASE_URL")
      url ->
        url
    end
  end
end
