defmodule ParserTest do
  use ExUnit.Case

  alias Revspin.Parser

  @expected_nr_of_brands 105

  setup_all do
    {:ok, html} = File.read("test/fixture/brands_and_blades.html")
    {:ok, html: html}
  end

  describe "Parser" do
    test "gets right number of brands", %{html: html} do
      assert @expected_nr_of_brands ==
               html
               |> Parser.parse_brands_blades_page()
               |> Enum.count()
    end

    test "gets proper format of data for blade producers", %{html: html} do
      brand_entity =
        html
        |> Parser.parse_brands_blades_page()
        |> Enum.at(1)

      assert Map.has_key?(brand_entity, :blades)
      assert Map.has_key?(brand_entity, :brand)

      assert %{brand: "tcore", blades: tcore_blades} = brand_entity
      assert Enum.count(tcore_blades) == 5
      assert %{link: "blade/tcore-a100.html", name: "A100"} = Enum.at(tcore_blades, 0)
    end

    test "correctly parses blade properties" do
      {:ok, html} = File.read("test/fixture/adidas_blade_with_ratings.html")

      assert [
               overall: 8.8,
               price: 190.0,
               speed: 8.8,
               control: 8.9,
               stiffness: 3.6,
               hardness: 4.3,
               consistency: 9.5
             ] == Parser.parse_blade_details_page(html)
    end

    test "doesn't fail on blades without ratings" do
      {:ok, html} = File.read("test/fixture/adidas_blade_without_ratings.html")

      assert [
               overall: nil,
               price: 150.0,
               speed: nil,
               control: nil,
               stiffness: nil,
               hardness: nil,
               consistency: nil
             ] == Parser.parse_blade_details_page(html)
    end
  end
end
