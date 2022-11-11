import Config

config :furigana, port: 80
config :furigana, database: "furigana_db"
config :furigana, pool_size: 3
config :furigana, :basic_auth, username: "user", password: "secret"
