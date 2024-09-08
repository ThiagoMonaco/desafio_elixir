defmodule Commands do

  @spec command([String.t() | integer | boolean | nil]) :: :ok
  def command(["SET", key, value] = _args) do
    DatabaseMap.put(key, value)
  end

  @spec command([String.t() | integer | boolean | nil]) :: :ok
  def command(["GET", key] = _args) do
    DatabaseMap.get(key)
    |> IO.inspect()
  end

  @spec command([String.t]) :: any
  def command([str_command]) do
    IO.puts("Comando inválido")
  end
end
