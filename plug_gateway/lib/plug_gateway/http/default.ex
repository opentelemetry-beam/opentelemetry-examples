defmodule PlugGateway.HTTP.Poisonous do
  @moduledoc """
  PlugGateway implementation for speaking to HTTP back ends.

  Adapts `c:PlugGateway.HTTP.API.get/1` to `HTTPoison.get/2`.

  Should you copy from _this_ code? See `PlugGateway.HTTP.API`.
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
