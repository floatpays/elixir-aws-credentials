defmodule AwsCredentials.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_credentials,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets],
      mod: {AwsCredentials.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hackney, "~> 1.18"},
      {:aws, "~> 0.12"},
      {:configparser_ex, "~> 4.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
