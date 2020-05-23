defmodule PlugGateway.BackendClient do

  def get(url, opts \\ []) do
    auth_token = PlugGateway.Config.get().auth_token
    headers = [{"authorization", "Bearer #{auth_token}"}]

    url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {:ok, status_code, body}
      {:error, reason} -> {:error, reason}
    end
  end
end
