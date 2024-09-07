defmodule StringResolver do
  @spec resolve_string(String.t) :: String.t
  def resolve_string(str) when is_binary(str) do
    escaped_str = String.replace(str, ~s("), ~s(\"))
    
    if String.starts_with?(str, ~s(")) and String.ends_with?(str, ~s(")) do
      String.slice(escaped_str, 1..-2//1)
    else
      escaped_str
    end
  end
end
