import Config

config :demo, Demo.Repo,
  # ssl: true,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: 10

config :demo, DemoWeb.Endpoint,
  server: true,
  url: [host: System.get_env("HOST") || "localhost"],
  http: [
    port: 4000,
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
