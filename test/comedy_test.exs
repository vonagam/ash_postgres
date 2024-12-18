defmodule AshPostgres.Test.ComedyTest do
  use AshPostgres.RepoCase, async: false
  alias AshPostgres.Test.{Comedian}
  require Ash.Query

  test "check" do
    Comedian
    |> Ash.Query.for_read(:search, %{}, authorize?: true)
    |> Ash.read!()

    Comedian
    |> Ash.Query.for_read(:search, %{}, authorize?: false)
    |> Ash.read!()
  end
end
