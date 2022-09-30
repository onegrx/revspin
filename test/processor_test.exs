defmodule ProcessorTest do
  use ExUnit.Case

  alias Revspin.Processor
  alias Revspin.RevspinAPIMock, as: APIMock

  import ExUnit.CaptureLog
  import Mox

  @adidas_eastfield_total_blades 29

  setup :verify_on_exit!

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Revspin.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Revspin.Repo, {:shared, self()})
  end

  describe "Processor" do
    test "processes" do
      expect(APIMock, :get_brands_blades_page, fn ->
        {:ok, File.read!("test/fixture/brands_and_blades_only_adidas_eastfield.html")}
      end)

      expect(APIMock, :get_blades_details, @adidas_eastfield_total_blades, fn _ ->
        {:ok, File.read!("test/fixture/adidas_blade_with_ratings.html")}
      end)

      log =
        capture_log([level: :info], fn ->
          :ok = Processor.process()
        end)

      assert log =~ "Processing brand: adidas"
      assert log =~ "Processing brand: eastfield"
    end
  end
end
