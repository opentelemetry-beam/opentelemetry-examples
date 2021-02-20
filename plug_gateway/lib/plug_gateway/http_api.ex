defmodule PlugGateway.HTTP.API do
  @moduledoc """
  PlugGateway API for speaking to HTTP back ends.
  """

  @doc "Get a URL."
  @callback get(
              url :: String.t(),
              headers: [{String.t(), iodata()}]
            ) :: {:ok, integer(), String.t()} | {:error, term()}
end

defmodule PlugGateway.HTTP.API.Poisonous do
  @moduledoc """
  PlugGateway implementation for speaking to HTTP back ends.

  Adapts `c:PlugGateway.HTTP.API.get/1` to `HTTPoison.get/2`.
  """

  @behaviour PlugGateway.HTTP.API

  @impl true
  def get(url, headers) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {:ok, status_code, body}
      {:error, reason} -> {:error, reason}
    end
  end
end
