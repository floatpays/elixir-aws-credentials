defmodule AwsCredentials.Client do
  def create(config) when is_map(config) do
    create(config[:region], config[:profile])
  end

  def create(region, profile \\ nil) do
    result =
      System.user_home()
      |> Path.join(".aws/credentials")
      |> File.read()

    case result do
      {:ok, credentials} ->
        sts_client(credentials, region, profile)

      _ ->
        %{
          "AccessKeyId" => access_key_id,
          "SecretAccessKey" => secret_access_key,
          "Token" => token
        } = AwsCredentials.Metadata.credentials()

        AWS.Client.create(access_key_id, secret_access_key, token, region)
    end
  end

  defp sts_client(credentials, region, profile) do
    {:ok, profiles} = ConfigParser.parse_string(credentials)

    role_arn = profiles[profile]["role_arn"]
    source_profile = profiles[profiles[profile]["source_profile"]]

    access_key_id = source_profile["aws_access_key_id"]
    secret_access_key = source_profile["aws_secret_access_key"]

    client = AWS.Client.create(access_key_id, secret_access_key, region)

    {:ok, response, _body} =
      AWS.STS.assume_role(client, %{
        "RoleSessionName" => "Ledger-Session",
        "RoleArn" => role_arn
      })

    %{
      "AssumeRoleResponse" => %{
        "AssumeRoleResult" => %{
          "Credentials" => %{
            "AccessKeyId" => access_key_id,
            "SecretAccessKey" => secret_access_key,
            "SessionToken" => session_token
          }
        }
      }
    } = response

    AWS.Client.create(
      access_key_id,
      secret_access_key,
      session_token,
      region
    )
  end
end
