defmodule Client do
  def get_blades_page do
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://revspin.net/blade/")
    body
  end
end
