import Config

config :revspin,
  ecto_repos: [Revspin.Repo]

config :revspin, Revspin.Repo,
  database: "revspin_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :revspin, Revspin.Processor,
  const_sleep_time: 200,
  random_sleep_time: 100

config :logger,
  level: :info
