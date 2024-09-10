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

  def convert_params(params) do
    regex = ~r/"[^"]*"|\w+/
    matches = Regex.scan(regex, params)
    List.flatten(matches)
  end

  def execute do
    command = IO.gets("> ")
    |> String.trim()
    |> String.split(" ", parts: 2)

    command_params = case Enum.at(command, 1) do
      nil -> []
      params -> convert_params(params)
    end

    [Enum.at(command, 0)] ++ command_params
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
