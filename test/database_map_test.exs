defmodule DatabaseMapTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = DatabaseMap.start_link()
    :ok
  end

  test "Should store and retrieves a value" do
    DatabaseMap.set("key1", "value1")

    assert {:ok, "value1"} == DatabaseMap.get("key1")
  end

  test "Should return error not found for non-existent key" do
    assert {:error, :not_found} == DatabaseMap.get("non_existent_key")
  end

  test "Should overwrite a value for an existing key" do
    DatabaseMap.set("key2", "initial_value")
    DatabaseMap.set("key2", "new_value")

    assert {:ok, "new_value"} == DatabaseMap.get("key2")
  end

  test "Should store and retrieve int values" do
    DatabaseMap.set("key3", 42)

    assert {:ok, 42} == DatabaseMap.get("key3")
  end

  test "Should store and retrieve boolean values" do
    DatabaseMap.set("key4", true)

    assert {:ok, true} == DatabaseMap.get("key4")
  end

  test "Should overwrites a value for an existing key when in a new transaction" do
    DatabaseMap.set("key5", "initial_value")
    DatabaseMap.start_transaction()
    DatabaseMap.set("key5", "new_value")

    assert {:ok, "new_value"} == DatabaseMap.get("key5")
  end

  test "Should apply transaction changes after commit" do
    DatabaseMap.set("key6", "initial_value")
    DatabaseMap.start_transaction()
    DatabaseMap.set("key6", "new_value")
    DatabaseMap.commit_transaction()

    assert {:ok, "new_value"} == DatabaseMap.get("key6")
  end
end

