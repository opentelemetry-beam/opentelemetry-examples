defmodule BasicElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :basic_elixir,
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
      mod: {BasicElixir.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:opentelemetry_api,
       github: "open-telemetry/opentelemetry-erlang", sparse: "apps/opentelemetry_api"},
      {:opentelemetry,
       github: "open-telemetry/opentelemetry-erlang", sparse: "apps/opentelemetry"},
      {:opentelemetry_exporter,
       github: "open-telemetry/opentelemetry-erlang", sparse: "apps/opentelemetry_exporter"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
