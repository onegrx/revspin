defmodule Revspin.Repo do
  use Ecto.Repo,
    otp_app: :revspin,
    adapter: Ecto.Adapters.Postgres
end
