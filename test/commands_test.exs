defmodule CommandsTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = DatabaseMap.start_link()
    :ok
  end

  test "Should store a value" do
    Commands.command(["SET", "key1", "value1"])
    assert DatabaseMap.get("key1") == "value1"
  end

  test "Should retrieve a value" do
    DatabaseMap.put("key2", "value2")
    assert Commands.command(["GET", "key2"]) == "value2"
  end
end
