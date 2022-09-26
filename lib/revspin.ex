defmodule Revspin do
  @moduledoc """
  Documentation for `Revspin`.
  """

  def start do
    html = Client.get_brands_blades_page()

    brand_entities =
      Parser.parse_brands_blades_page(html)
      # ! For development
      |> Enum.take(4)

    # :ok =
    #   brand_entities
    #   |> Enum.map(& &1.brand)
    #   |> Enum.map(fn brand_name -> %Brand{name: brand_name} end)
    #   |> Enum.each(&Revspin.Repo.insert/1)

    # IO.puts("Waiting...")
    # Process.sleep(2500)

    brand_entities
    |> Enum.each(&process_blades_from_brand/1)
  end

  defp process_blades_from_brand(%{blades: blades, brand: brand_name}) do
    IO.puts("Brand name: #{brand_name}")

    brand = %Brand{name: brand_name}
    {:ok, insertion_result} = Revspin.Repo.insert(brand) |> IO.inspect()

    blades
    # ! For development
    |> Enum.take(4)
    |> Enum.each(fn blade -> process_blade(blade, insertion_result) end)
  end

  defp process_blade(%{link: link, name: blade_name}, inserted_brand) do
    case Client.get_blades_details(link) do
      {:ok, blade_html} ->
        attrs = Parser.parse_blade_details_page(blade_html)
        attrs = Keyword.put(attrs, :name, blade_name)
        IO.puts(" * BLADE: #{blade_name} - attrs: #{inspect(attrs)}")

        blade =
          Ecto.build_assoc(inserted_brand, :blades, attrs)
          |> Revspin.Repo.insert
          |> IO.inspect()

        Process.sleep(1000 + :rand.uniform(500))

      _ ->
        IO.puts(" * BLADE: #{blade_name} - 404 SKIP")
    end
  end
end
