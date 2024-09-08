defmodule Commands do

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["SET", key, value] = _args) do
    case DatabaseMap.set(key, value) do
      {:ok, :new} -> ~s(FALSE #{value})
      {:ok, :existing} -> ~s(TRUE #{value})
    end
  end

  @spec command([String.t() | integer | boolean | nil]) :: any
  def command(["GET", key] = _args) do
    case DatabaseMap.get(key) do
      {:ok, value} -> value
      {:error, :not_found} -> nil
    end
  end

  @spec command([String.t]) :: any
  def command([str_command]), do: ~s(ERR: "No command #{str_command}")
end
