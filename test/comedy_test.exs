defmodule AshPostgres.Test.ComedyTest do
  use AshPostgres.RepoCase, async: false
  alias AshPostgres.Test.{Comedian}
  require Ash.Query

  test "check" do
    commedian = Comedian.create!(%{name: "John"})

    Ash.load!(commedian, :jokes)
  end
end
