defmodule CommandsTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = DatabaseMap.start_link()
    :ok
  end

  test "Should store a value" do
    Commands.command(["SET", "key1", "value1"])
    assert {:ok, "value1"} == DatabaseMap.get("key1")
  end

  test "Should retrieve a value" do
    DatabaseMap.put("key2", "value2")
    assert {:ok, "value2"} == Commands.command(["GET", "key2"])
  end
end
