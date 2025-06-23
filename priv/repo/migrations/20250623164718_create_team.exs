defmodule GateRush.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :owner, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
