defmodule Commands do

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["SET", key, value] = _args) do
    case DatabaseMap.set(key, value) do
      {:ok, :new} -> ~s(FALSE #{value})
      {:ok, :existing} -> ~s(TRUE #{value})
    end
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["GET", key] = _args) do
    case DatabaseMap.get(key) do
      {:ok, value} -> ~s(#{value})
      {:error, :not_found} -> ~s(NIL)
    end
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["BEGIN"] = _args) do
    {:ok, deep} = DatabaseMap.start_transaction()
    ~s(#{deep})
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["COMMIT"] = _args) do
    {:ok, deep} = DatabaseMap.commit_transaction()
    ~s(#{deep})
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["ROLLBACK"] = _args) do
    {:ok, deep} = DatabaseMap.rollback()
    ~s(#{deep})
  end

  @spec command([String.t]) :: any
  def command([str_command | _rest]), do: ~s(ERR: "No command #{str_command}")
end
