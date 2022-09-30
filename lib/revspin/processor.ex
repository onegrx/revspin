defmodule Revspin.Processor do
  @moduledoc "Module responsible for processing brands and blades"

  alias Revspin.APIClient
  alias Revspin.Model.Brand
  alias Revspin.Parser
  alias Revspin.Repo

  require Logger

  @api_client Application.compile_env(:revspin, [__MODULE__, :api_client], APIClient)

  def process do
    {:ok, html} = @api_client.get_brands_blades_page()

    html
    |> Parser.parse_brands_blades_page()
    |> Enum.each(&process_brand_with_blades/1)
  end

  defp process_brand_with_blades(%{blades: blades, brand: brand_name}) do
    Logger.info("Processing brand: #{brand_name}", ansi_color: :blue)

    brand = %Brand{name: brand_name}
    {:ok, inserted_brand} = Repo.insert(brand)

    concurrency = Application.get_env(:revspin, __MODULE__)[:concurrency]

    blades
    |> Task.async_stream(fn blade -> process_blade(blade, inserted_brand) end,
      max_concurrency: concurrency
    )
    |> Enum.to_list()
  end

  defp process_blade(%{link: link, name: blade_name}, inserted_brand) do
    case @api_client.get_blades_details(link) do
      {:ok, blade_html} ->
        attrs =
          blade_html
          |> Parser.parse_blade_details_page()
          |> Keyword.put(:name, blade_name)

        Logger.info("Processing blade: #{blade_name}", ansi_color: :magenta)

        inserted_brand
        |> Ecto.build_assoc(:blades, attrs)
        |> Repo.insert()

        sleep_config = Application.get_env(:revspin, __MODULE__)
        sleep_time = sleep_config[:const_sleep_time] + rand(sleep_config[:random_sleep_time])

        Process.sleep(sleep_time)

      {:error, _} ->
        Logger.warn("Unable to load page for blade: #{blade_name} - skipping")
    end
  end

  defp rand(0), do: 0
  defp rand(n), do: :rand.uniform(n)
end
