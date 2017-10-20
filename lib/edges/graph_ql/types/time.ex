defmodule Edges.GraphQL.Types.Time do
  use Absinthe.Schema.Notation

  scalar :time, description: "ISOz time since Unix Epoch" do
    parse &Timex.parse(&1.value, "{s-epoch}")
    serialize &Timex.format!(&1, "{s-epoch}")
  end
end
