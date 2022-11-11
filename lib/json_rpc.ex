defmodule JsonRpc do
  require Application
  require HTTPoison

  @url "https://jlp.yahooapis.jp/FuriganaService/V2/furigana"

  def get_furigana(text) do
    headers = [{"Content-Type", "application/json"}, {"User-Agent", "Yahoo AppID: #{api_id()}"}]

    params = %{
      id: "1",
      jsonrpc: "2.0",
      method: "jlp.furiganaservice.furigana",
      params: %{
        q: text,
        grade: 1
      }
    }

    body = Jason.encode!(params)

    case HTTPoison.post(@url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("result")
        |> Map.get("word")
        |> Enum.map(fn word -> furigana(word) end)
        |> Enum.join("")

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        []
    end
  end

  defp furigana(%{"furigana" => value, "surface" => _}) do
    value
  end

  defp furigana(%{"surface" => value}) do
    value
  end

  defp api_id do
    Application.get_env(:furigana, :api_id)
  end
end
