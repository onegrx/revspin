defmodule Revspin do
  @moduledoc """
    Provides an API to fetch, process and save tennis blades with brands from revspin.net webpage.
    Contains a single method "start".
  """

  defdelegate start, to: Revspin.Processor, as: :process
end
