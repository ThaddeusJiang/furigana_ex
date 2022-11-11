defmodule Furigana.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Plug.Cowboy,
        scheme: :http,
        plug: Furigana.Router,
        options: [port: Application.get_env(:furigana, :port)]
      }
    ]

    opts = [strategy: :one_for_one, name: Furigana.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
