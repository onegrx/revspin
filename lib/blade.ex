defmodule Blade do
  @moduledoc "Schema representing a tennis blade"

  use Ecto.Schema

  @fields ~w(
    name
    overall
    price
    speed
    control
    stiffness
    hardness
    consistency
  )a

  schema "blades" do
    field :name, :string

    field :overall, :float
    field :price, :float

    field :speed, :float
    field :control, :float
    field :stiffness, :float
    field :hardness, :float
    field :consistency, :float

    belongs_to :brand, Brand

    timestamps()
  end
end
