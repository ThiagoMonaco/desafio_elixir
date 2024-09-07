defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """

  alias StringResolver

  def main(_args) do
    command = IO.gets(">")

    String.split(command, ", ")
    |> Enum.map(&StringResolver.resolve_string/1)
    |> Enum.each(&IO.inspect/1)
  end
end
