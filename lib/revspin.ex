defmodule Revspin do
  @moduledoc """
  Documentation for `Revspin`.
  """

  def start do
    html = Client.get_blades_page()
    Parser.parse_blades_page(html)
  end
end
