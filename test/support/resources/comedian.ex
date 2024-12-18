defmodule AshPostgres.Test.Comedian do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key(:id)
    attribute(:name, :string, public?: true)
    create_timestamp(:inserted_at, public?: true)
    update_timestamp(:updated_at, public?: true)
  end

  relationships do
    has_many(:jokes, AshPostgres.Test.Joke, public?: true, no_attributes?: true, filter: expr(comedian_id == parent(id)))
  end

  calculations do
    calculate(
      :latest_joke_at,
      :utc_datetime,
      expr(fragment("COALESCE(?, ?)", max(jokes, field: :inserted_at), inserted_at))
    )
  end

  actions do
    defaults([:read])

    read :search do
      prepare(build(
        select: [:name],
        sort: [latest_joke_at: :desc],
        limit: 10
      ))
    end

    create :create do
      primary? true
      accept [:name]
    end
  end

  code_interface do
    define :create
  end

  policies do
    policy action([:read, :search]) do
      authorize_if(always())
    end
  end

  postgres do
    table("comedians")
    repo(AshPostgres.TestRepo)
  end
end
