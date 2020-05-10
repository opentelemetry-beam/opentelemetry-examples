use Mix.Config

# Configures Elixir's logger so you can see the trace metadata:
config :logger, :console,
  format: "[$level] $message\n\t$metadata\n",
  metadata: :all

if Mix.env() in [:test], do: import_config("#{Mix.env()}.exs")
