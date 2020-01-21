defmodule PhoenixBackend.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_backend,
    adapter: Ecto.Adapters.Postgres

  alias Vapor.Provider.{Dotenv, Env}

  def init(_, config) do
    providers = [
      %Dotenv{},
      %Env{bindings: [
        url: "DATABASE_URL"
      ]},
    ]

    runtime_config = Vapor.load!(providers) |> Enum.into([])

    {:ok, Keyword.merge(config, runtime_config)}
  end
end
