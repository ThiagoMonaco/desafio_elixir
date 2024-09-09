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

  test "Should discard transaction changes after rollback" do
    DatabaseMap.set("key7", "initial_value")
    DatabaseMap.start_transaction()
    DatabaseMap.set("key7", "new_value")
    DatabaseMap.rollback()

    assert {:ok, "initial_value"} == DatabaseMap.get("key7")
  end

  test "Should discard changes after a rollback on a commited transaction" do
    DatabaseMap.set("key8", "initial_value")
    DatabaseMap.start_transaction()
    DatabaseMap.set("key8", "new_value")
    DatabaseMap.start_transaction()
    DatabaseMap.set("key8", "new_value2")
    DatabaseMap.commit_transaction()
    DatabaseMap.rollback()

    assert {:ok, "initial_value"} == DatabaseMap.get("key8")
  end

  test "Begin should return correct transaction depth" do
    DatabaseMap.start_transaction()
    DatabaseMap.start_transaction()

    assert {:ok, 3} == DatabaseMap.start_transaction()
  end

  test "Commit should return correct transaction depth" do
    DatabaseMap.start_transaction()
    DatabaseMap.start_transaction()
    DatabaseMap.commit_transaction()

    assert {:ok, 0} == DatabaseMap.commit_transaction()
  end

  test "Rollback should return correct transaction depth" do
    DatabaseMap.start_transaction()
    DatabaseMap.start_transaction()
    DatabaseMap.rollback()

    assert {:ok, 0} == DatabaseMap.rollback()
  end
end

