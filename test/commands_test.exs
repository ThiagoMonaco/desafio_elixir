defmodule CommandsTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = DatabaseMap.start_link()
    :ok
  end

  test "Should store a value" do
    assert ~s(FALSE value1) == Commands.command(["SET", "key1", "value1"])
    assert {:ok, "value1"} == DatabaseMap.get("key1")
  end

  test "Should retrieve a value" do
    DatabaseMap.set("key2", "value2")
    assert "value2" == Commands.command(["GET", "key2"])
  end

  test "Should return error message when command is invalid" do
    assert ~s(ERR: "No command INVALID") == Commands.command(["INVALID"])
  end
end
