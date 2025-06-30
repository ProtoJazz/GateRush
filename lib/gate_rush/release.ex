defmodule GateRush.Release do
  @moduledoc false
  alias Ecto.Migrator
  alias GateRush.Repo

  def migrate do
    load_app()

    for repo <- Application.fetch_env!(:gate_rush, :ecto_repos) do
      IO.puts("Running migrations for #{inspect(repo)}...")
      {:ok, _} = repo.start_link()
      Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  defp load_app do
    Application.load(:gate_rush)
    Enum.each(Application.spec(:gate_rush, :applications), &Application.ensure_all_started/1)
  end

  defp migrations_path(repo) do
    app = Keyword.fetch!(repo.config(), :otp_app)
    priv_dir = :code.priv_dir(app)
    Path.join([priv_dir, "repo", "migrations"])
  end
end
