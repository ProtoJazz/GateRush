defmodule GateRush.Repo do
  use Ecto.Repo,
    otp_app: :gate_rush,
    adapter: Ecto.Adapters.Postgres
end
