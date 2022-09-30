defmodule Revspin.APIClient do
  @moduledoc "HTTP client implementation to access blades data from RevSpin website"

  @behaviour Revspin.API

  @spec get_brands_blades_page() :: String.t()
  def get_brands_blades_page do
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://revspin.net/blade/")
    body
  end

  @spec get_blades_details(String.t()) ::
          {:ok, String.t()} | {:error, :not_found} | {:error, any()}
  def get_blades_details(link) do
    case HTTPoison.get("https://revspin.net/" <> link) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
    end
  end
end
