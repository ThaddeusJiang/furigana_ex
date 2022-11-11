defmodule Furigana.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "pass your word after /, just like this: /神奈川県横浜市")
  end

  get "/:word" do
    furigana = JsonRpc.get_furigana(word)

    conn
    |> prepend_resp_headers([{"content-type", "application/json"}])
    |> send_resp(200, furigana)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
