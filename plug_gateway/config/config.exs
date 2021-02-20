use Mix.Config

config :logger, :console,
  format: "[$level] $message\n\t$metadata\n",
  metadata: :all

config :plug_gateway,
  api_endpoint: System.get_env("BACKEND_API_URL"),
  auth_token: System.get_env("BACKEND_AUTH_TOKEN"),
  port: String.to_integer(System.get_env("PORT", "4000"))

if Mix.env() in [:test], do: import_config("#{Mix.env()}.exs")
