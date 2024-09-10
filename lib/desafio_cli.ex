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
  alias Commands

  def execute do
    command = IO.gets("> ") |> String.trim()

    String.split(command, " ", parts: 3)
    |> Enum.map(&TypeConverter.convert/1)
    |> Commands.command()
    |> IO.puts()

    execute()
  end

  def main(_args) do
    DatabaseMap.start_link()
    execute()
  end
end
