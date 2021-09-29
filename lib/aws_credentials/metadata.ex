defmodule AwsCredentials.Metadata do
  def credentials() do
    case System.get_env("AWS_CONTAINER_CREDENTIALS_RELATIVE_URI") do
      nil -> %{}
      path -> get("http://169.254.170.2" <> path) |> Jason.decode!()
    end
  end

  defp get(path) do
    case :httpc.request(:get, {to_charlist(path), []}, [], []) do
      {:ok, {_, _, body}} -> body |> to_string
      _ -> "Unable to retrieve"
    end
  end
end
