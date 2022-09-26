defmodule Brand do
  @moduledoc "Schema representing brand of the tennis blade"

  use Ecto.Schema

  schema "brands" do
    field :name, :string

    has_many :blades, Blade

    timestamps()
  end
end
