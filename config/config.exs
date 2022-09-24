import Config

config :revspin,
  ecto_repos: [Revspin.Repo]

config :revspin, Revspin.Repo,
  database: "revspin_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
