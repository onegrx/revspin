defmodule ProcessorTest do
  use ExUnit.Case

  alias Revspin.Processor
  alias Revspin.RevspinAPIMock, as: APIMock

  import Mox

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Revspin.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Revspin.Repo, {:shared, self()})
  end

  describe "Processor" do
    test "processes" do
      expect(APIMock, :get_brands_blades_page, fn ->
        File.read!("test/fixture/brands_and_blades.html")
      end)

      stub(APIMock, :get_blades_details, fn _ ->
        {:ok, File.read!("test/fixture/adidas_blade_with_ratings.html")}
      end)

      assert :ok == Processor.process()
    end
  end
end
