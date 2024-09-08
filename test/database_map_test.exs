defmodule DatabaseMapTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = DatabaseMap.start_link()
    :ok
  end

  test "Should store and retrieves a value" do
    DatabaseMap.put("key1", "value1")

    assert "value1" == DatabaseMap.get("key1")
  end

  test "Should return nil for non-existent key" do
    assert nil == DatabaseMap.get("non_existent_key")
  end

  test "Should overwrite a value for an existing key" do
    DatabaseMap.put("key2", "initial_value")
    DatabaseMap.put("key2", "new_value")

    assert "new_value" == DatabaseMap.get("key2")
  end

  test "Should store and retrieve int values" do
    DatabaseMap.put("key3", 42)

    assert 42 == DatabaseMap.get("key3")
  end

  test "Should store and retrieve boolean values" do
    DatabaseMap.put("key4", true)

    assert true == DatabaseMap.get("key4")
  end
end

