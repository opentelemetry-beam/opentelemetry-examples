defmodule PlugGateway.Config do
  @moduledoc """
  PlugGateway application.

  Should you copy from _this_ code? We're using `Vapor` because it can load environment variables
  straight from `.env` files, saving you having to do so, and gives good error messages. We're
  using `Norm` as an extra layer of protection. It's probably overkill here, but it's more handy
  in `PlugGateway.HTTP`, and it comes for free with `Vapor`.
  """

  use Norm

  @keys [:backend_api_endpoint, :backend_auth_token, :port]
  defstruct @keys

  @doc "Get the router config."
  @contract config() ::
              schema(%{
                backend_api_endpoint: spec(is_binary() and (&set?/1)),
                backend_auth_token: spec(is_binary() and (&set?/1)),
                port: spec(is_integer())
              })
  def config do
    providers = [
      %Vapor.Provider.Dotenv{},
      %Vapor.Provider.Env{
        bindings: [
          {:backend_api_endpoint, "BACKEND_API_URL"},
          {:backend_auth_token, "BACKEND_AUTH_TOKEN"},
          {:port, "PORT", default: 4000, map: &String.to_integer/1}
        ]
      }
    ]

    Kernel.struct!(__MODULE__, Vapor.load!(providers))
  end

  defp set?(""), do: false
  defp set?(_), do: true
end
