defmodule Client do
  def get_brands_blades_page do
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://revspin.net/blade/")
    body
  end

  def get_blades_details(link) do
    case HTTPoison.get!("https://revspin.net/" <> link) do
      %HTTPoison.Response{body: body, status_code: 200} -> {:ok, body}
      %HTTPoison.Response{status_code: 404} -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
    end

    # %HTTPoison.Response{body: body, status_code: 200} = response = HTTPoison.get!("https://revspin.net/" <> link)
    # IO.inspect(response)
    # body
  end
end
