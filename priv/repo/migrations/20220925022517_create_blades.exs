defmodule Revspin.Repo.Migrations.CreateBlades do
  use Ecto.Migration

  def change do
    create table(:blades) do
      add :name, :string

      add :overall, :float
      add :price, :float

      add :speed, :float
      add :control, :float
      add :stiffness, :float
      add :hardness, :float
      add :consistency, :float

      add :brand_id, references(:brands)

      timestamps()
    end
  end
end
