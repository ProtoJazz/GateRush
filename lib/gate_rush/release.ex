defmodule GateRush.Release do
  @moduledoc false
  alias Ecto.Migrator
  alias GateRush.Repo

  def migrate do
    Application.load(:gate_rush)

    for repo <- Application.fetch_env!(:gate_rush, :ecto_repos) do
      IO.puts("Running migrations for #{inspect(repo)}...")
      Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  defp migrations_path(repo) do
    app = Keyword.fetch!(repo.config, :otp_app)
    priv_dir = :code.priv_dir(app)
    Path.join([priv_dir, "repo", "migrations"])
  end
end
