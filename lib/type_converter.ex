defmodule TypeConverter do
  
  alias StringResolver

  @spec convert(String.t) :: boolean
  def convert("TRUE"), do: true

  @spec convert(String.t) :: boolean 
  def convert("FALSE"), do: false

  @spec convert(String.t) :: String.t | integer
  def convert(str) do
    case Integer.parse(str) do
      {int, _} -> int
      :error -> StringResolver.resolve_string(str)
    end
  end
end

