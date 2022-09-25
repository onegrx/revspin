defmodule Parser do
  @moduledoc "HTML parser for extracting brands and blades data from RevSpin"

  @blade_properties ~w(speed control stiffness hardness consistency)a

  def parse_brands_blades_page(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.find(".dbcat + div")
    |> Enum.map(&process_brand_node/1)
  end

  def parse_blade_details_page(html) do
    {:ok, document} = Floki.parse_document(html)

    [{"span", _, [price_string]}] = Floki.find(document, "#actual_price")
    price = string_to_number(price_string)

    [{"span", _, [{"span", _, [overall_string]}]}] = Floki.find(document, "span.rating")

    overall = string_to_number(overall_string)

    document
    |> Floki.find("#UserRatingsTable td.cell_rating")
    |> Enum.take(length(@blade_properties))
    |> Enum.map(fn td ->
      {"td", _attrs, [val | _]} = td
      string_to_number(val)
    end)
    |> Enum.zip(@blade_properties)
    |> Enum.map(fn {val, prop} -> {prop, val} end)
    |> Keyword.put(:price, price)
    |> Keyword.put(:overall, overall)
  end

  defp process_brand_node({"div", attributes, children_nodes}) do
    {"id", brand_tag_id} = List.keyfind(attributes, "id", 0)
    brand_name = extract_brand_name(brand_tag_id)

    blades =
      children_nodes
      |> Floki.find("tr")
      |> Enum.drop(1)
      |> Enum.map(&get_blade_name_link/1)

    %{brand: brand_name, blades: blades}
  end

  defp extract_brand_name("brand-" <> brand_name), do: brand_name

  defp get_blade_name_link(blade_tr) do
    [{"a", attributes, children}] = Floki.find(blade_tr, "a")
    {"href", link} = List.keyfind(attributes, "href", 0)
    [_span, blade_name] = children

    %{name: String.trim(blade_name), link: link}
  end

  defp string_to_number(string) do
    string
    |> String.trim()
    |> Float.parse()
    |> case do
      {float, ""} -> float
      _ -> nil
    end
  end
end
