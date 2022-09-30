defmodule Revspin.API do
  @moduledoc "API behaviour for RevSpin website"

  @type response ::
          {:ok, String.t()}
          | {:error, :not_found}
          | {:error, :unexpected_response}
          | {:error, any()}

  @callback get_brands_blades_page :: response()

  @callback get_blades_details(String.t()) :: response()
end
