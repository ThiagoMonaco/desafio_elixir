defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  alias TypeConverter
  alias DatabaseMap

  def main(_args) do
    command = IO.gets(">")

    DatabaseMap.start_link()
    DatabaseMap.put("key1", "value1")
    DatabaseMap.put("key2", "value2")

    IO.inspect(DatabaseMap.get("key1"))
    IO.inspect(DatabaseMap.get("key2"))

    String.split(command, ", ")
    |> Enum.map(&TypeConverter.convert/1)
    |> Enum.each(&IO.inspect/1)
  end
end
