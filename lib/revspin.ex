defmodule Revspin do
  @moduledoc """
  Documentation for `Revspin`.
  """

  def start do
    html = Client.get_brands_blades_page()

    brand_entities =
      Parser.parse_blades_page(html)
      # ! For development
      |> Enum.slice(0..3)
      # |> Enum.slice(1..6)
      # |> Enum.at(2)
      |> Enum.each(&process_blades_from_brand/1)

    # brand = %Brand{name: "adidas"}
    # Revspin.Repo.insert(brand)
  end

  defp process_blades_from_brand(brand_entity) do
    %{
      blades: blades,
      brand: brand_name
    } = brand_entity

    IO.puts("Brand name: #{brand_name}")

    blades
    # ! For development
    |> Enum.take(4)
    |> Enum.each(fn blade -> process_blade(blade) end)
  end

  defp process_blade(%{link: link, name: blade_name} = blade) do
    case Client.get_blades_details(link) do
      {:ok, blade_html} ->
        price = Parser.parse_blade_details_page(blade_html)
        IO.puts("  * BLADE: #{blade_name} - price: #{price}")
        Process.sleep(1000 + :rand.uniform(500))

      _ ->
        IO.puts("  * BLADE: #{blade_name} - 404 SKIP")
    end
  end
end
