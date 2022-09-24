defmodule RevspinTest do
  use ExUnit.Case
  doctest Revspin

  setup_all do
    {:ok, html} = File.read("fixture/blades.html")
    {:ok, html: html}
  end

  test "gets right number of blades", %{html: html} do
    n = 105

    assert n ==
             html
             |> Parser.parse_blades_page()
             |> Enum.count()
  end

  test "gets proper format of data for blade producers", %{html: html} do
    brand_entity =
      html
      |> Parser.parse_blades_page()
      |> Enum.at(1)

    assert Map.has_key?(brand_entity, :blades)
    assert Map.has_key?(brand_entity, :brand)

    assert %{brand: "tcore", blades: tcore_blades} = brand_entity
    assert Enum.count(tcore_blades) == 5
    assert %{link: "blade/tcore-a100.html", name: "A100"} = Enum.at(tcore_blades, 0)
  end

  test "correctly parses blade price" do
    {:ok, html} = File.read("fixture/adidas_blade.html")
    assert Parser.parse_blade_details_page(html) == 190
  end
end
