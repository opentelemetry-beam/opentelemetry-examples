defmodule PlugGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_gateway,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PlugGateway.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:mox, "~> 0.5.2", only: :test},
      {:norm, "~> 0.9"},
      {:opentelemetry_api, "~> 0.3.1"},
      {:opentelemetry_plug,
       git: "https://github.com/opentelemetry-beam/opentelemetry_plug.git", tag: "update-name"},
      {:opentelemetry, "~> 0.4.0"},
      {:plug_cowboy, "~> 2.1"},
      {:plug,
       git: "https://github.com/tsloughter/plug.git", tag: "dispatch-telemetry", override: true},
      {:vapor, "~> 0.5"}
    ]
  end
end
