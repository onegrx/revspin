defmodule Revspin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Revspin.Worker.start_link(arg)
      # {Revspin.Worker, arg}
      Revspin.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Revspin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
