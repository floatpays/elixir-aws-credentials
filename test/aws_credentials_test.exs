defmodule AwsCredentialsTest do
  use ExUnit.Case
  doctest AwsCredentials

  test "greets the world" do
    assert AwsCredentials.hello() == :world
  end
end
