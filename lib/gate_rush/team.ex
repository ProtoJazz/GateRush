defmodule GateRush.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :owner, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(teams, attrs) do
    teams
    |> cast(attrs, [:name, :owner])
    |> validate_required([:name, :owner])
  end
end
