defmodule TypeConverterTest do
  use ExUnit.Case
  doctest TypeConverter

  test "Should convert string TRUE to boolean true" do
    assert TypeConverter.convert("TRUE") == true
  end

  test "Should convert string FALSE to boolean false" do
    assert TypeConverter.convert("FALSE") == false
  end

  test "Should convert string 123 to integer 123" do
    assert TypeConverter.convert("123") == 123
  end

  test "Should convert string TRUE to string TRUE" do
    assert TypeConverter.convert(~s("TRUE")) == "TRUE"
  end

  test "Should convert string 123 to string 123" do
    assert TypeConverter.convert(~s("123")) == "123"
  end

  test "should convert nil to nil" do
    assert TypeConverter.convert(nil) == nil
  end

  test "should convert string nil to nil" do
    assert TypeConverter.convert(~s(NIL)) == nil
  end
end
