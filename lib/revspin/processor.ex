defmodule Revspin.Processor do
  @moduledoc "Module responsible for processing brands and blades"

  alias Revspin.Client
  alias Revspin.Model.Brand
  alias Revspin.Parser
  alias Revspin.Repo

  require Logger

  def process do
    html = Client.get_brands_blades_page()

    html
    |> Parser.parse_brands_blades_page()
    |> Enum.take(4)
    |> Enum.each(&process_brand_with_blades/1)
  end

  defp process_brand_with_blades(%{blades: blades, brand: brand_name}) do
    Logger.info("Processing brand: #{brand_name}", ansi_color: :blue)

    brand = %Brand{name: brand_name}
    {:ok, inserted_brand} = Repo.insert(brand)

    blades
    |> Enum.take(4)
    |> Enum.each(fn blade -> process_blade(blade, inserted_brand) end)
  end

  defp process_blade(%{link: link, name: blade_name}, inserted_brand) do
    case Client.get_blades_details(link) do
      {:ok, blade_html} ->
        attrs =
          blade_html
          |> Parser.parse_blade_details_page()
          |> Keyword.put(:name, blade_name)

        Logger.info("Processing blade: #{blade_name}", ansi_color: :magenta)

        inserted_brand
        |> Ecto.build_assoc(:blades, attrs)
        |> Repo.insert()

        Process.sleep(1000 + :rand.uniform(500))

      _ ->
        Logger.warn("Unable to load page for blade: #{blade_name} - skipping")
    end
  end
end
