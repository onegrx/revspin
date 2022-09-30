defmodule Revspin.API do
  @moduledoc "API behaviour for RevSpin website"

  @callback get_brands_blades_page() :: String.t()

  @callback get_blades_details(String.t()) ::
          {:ok, String.t()} | {:error, :not_found} | {:error, any()}

end
