import Config

config :revspin,
  ecto_repos: [Revspin.Repo]

config :revspin, Revspin.Repo,
  database: "revspin_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :revspin, Revspin.Processor,
  const_sleep_time: 2000,
  random_sleep_time: 1000,
  concurrency: 6

config :logger,
  level: :info

import_config("#{Mix.env()}.exs")
