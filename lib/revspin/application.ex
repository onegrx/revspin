defmodule Revspin.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Revspin.Repo
    ]

    opts = [strategy: :one_for_one, name: Revspin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
