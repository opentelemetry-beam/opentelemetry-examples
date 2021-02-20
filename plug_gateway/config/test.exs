use Mix.Config

config :plug_gateway,
  api_endpoint: "http://api.example.com/api",
  auth_token: "BACKEND_AUTH_TOKEN",
  http_module: PlugGateway.HTTPMock
