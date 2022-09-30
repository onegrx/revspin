defmodule Revspin.APIClient do
  @moduledoc "HTTP client implementation to access blades data from RevSpin website"

  @behaviour Revspin.API

  @spec get_brands_blades_page() :: Revspin.API.response()
  def get_brands_blades_page do
    HTTPoison.get("https://revspin.net/blade/") |> handle
  end

  @spec get_blades_details(String.t()) :: Revspin.API.response()
  def get_blades_details(link) do
    HTTPoison.get("https://revspin.net/" <> link) |> handle
  end

  defp handle(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
      {:ok, _} -> {:error, :unexpected_response}
      {:error, reason} -> {:error, reason}
    end
  end
end
