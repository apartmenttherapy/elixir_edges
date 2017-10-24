defmodule Edges.Mixfile do
  use Mix.Project

  def project do
    [
      app: :edges,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :absinthe, ">= 0.0.0"},
      { :absinthe_ecto, ">= 0.0.0"},
      { :postgrex, ">= 0.0.0" },
      { :ecto, ">= 0.0.0"},
      { :timex, ">= 0.0.0" },
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test),      do: ["lib", "test/support"]
  defp elixirc_paths(_),          do: ["lib"]

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.reset", "test"]
    ]
  end
end
