defmodule Commands do

  def command(["SET", key, value] = _args) do
    DatabaseMap.put(key, value)
  end

  def command(["GET", key] = _args) do
    DatabaseMap.get(key)
    |> IO.inspect()
  end
end
