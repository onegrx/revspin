defmodule Revspin.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string
    end
  end
end
