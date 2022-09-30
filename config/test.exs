import Config

config :revspin, Revspin.Processor,
  const_sleep_time: 0,
  random_sleep_time: 0,
  api_client: Revspin.RevspinAPIMock

config :revspin, Revspin.Repo,
  database: "revspin_repo_test",
  pool: Ecto.Adapters.SQL.Sandbox
