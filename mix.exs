defmodule Revspin.MixProject do
  use Mix.Project

  def project do
    [
      app: :revspin,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Revspin.Application, []}
    ]
  end

  defp aliases do
    [
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:floki, "~> 0.33.0"},
      {:httpoison, "~> 1.8"},
      {:postgrex, "~> 0.16.5"}
    ]
  end
end
