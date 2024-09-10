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

  test "Should return error message when command is invalid with more than one argument" do
    assert ~s(ERR: "No command INVALID") == Commands.command(["INVALID", "arg1", "arg2"])
  end

  test "Should return error message when SET command is invalid" do
    assert ~s(ERR "SET <chave> <valor> - Syntax error") == Commands.command(["SET"])
  end

  test "Should return error message when GET command is invalid" do
    assert ~s(ERR "GET <chave> - Syntax error") == Commands.command(["GET"])
  end

  test "Should return error message when BEGIN command is invalid" do
    assert ~s(ERR "BEGIN - Syntax error") == Commands.command(["BEGIN", "arg1"])
  end

  test "Should return error message when COMMIT command is invalid" do
    assert ~s(ERR "COMMIT - Syntax error") == Commands.command(["COMMIT", "arg1"])
  end

  test "Should return error message when ROLLBACK command is invalid" do
    assert ~s(ERR "ROLLBACK - Syntax error") == Commands.command(["ROLLBACK", "arg1"])
  end
end
