defmodule Parser do
  def parse_blades_page(html) do
    {:ok, document} = Floki.parse_document(html)

    brands = Floki.find(document, ".dbcat + div")

    # IO.inspect("Brand count: #{Enum.count(brands)}")

    brands
    |> Enum.map(&process_brand_node/1)

    # |> Enum.slice(1..3)
  end

  defp process_brand_node({"div", attributes, children_nodes}) do
    {"id", brand_tag_id} = List.keyfind(attributes, "id", 0)
    brand_name = extract_brand_name(brand_tag_id)

    blades =
      children_nodes
      |> Floki.find("tr")
      |> Enum.drop(1)
      |> Enum.map(&get_blade_name_link/1)

    %{
      brand: brand_name,
      blades: blades
    }
  end

  defp extract_brand_name("brand-" <> brand_name), do: brand_name

  defp get_blade_name_link(blade_tr) do
    [{"a", attributes, children}] = Floki.find(blade_tr, "a")
    {"href", link} = List.keyfind(attributes, "href", 0)
    [_span, blade_name] = children

    %{
      name: String.trim(blade_name),
      link: link
    }
  end
end
