defmodule StringResolverTest do
  use ExUnit.Case
  doctest StringResolver

  test "Should convert string without double quotes correctly" do
    string = ~s(string)
    assert StringResolver.resolve_string(string) == ~s(string)
  end
  
  test "Should convert string with double quotes correctly" do
    string = ~s("string")
    assert StringResolver.resolve_string(string) == ~s(string)
  end

  test "Should convert string with inner double quotes correctly" do
    string = ~s("\"string\"")
    assert StringResolver.resolve_string(string) == ~s("string")
  end

  test "Should convert string with number correctly" do
    string = ~s("123")
    assert StringResolver.resolve_string(string) == ~s(123)
  end

  test "Should convert string with boolean correctly" do
    string = ~s("TRUE")
    assert StringResolver.resolve_string(string) == ~s(TRUE)
  end
end

