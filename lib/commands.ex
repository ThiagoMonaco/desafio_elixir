defmodule Commands do


  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["SET", key, value] = _args) do
    case DatabaseMap.set(key, value) do
      {:ok, :new} -> ~s(FALSE #{value})
      {:ok, :existing} -> ~s(TRUE #{value})
    end
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["SET" | _] = _args) do
    ~s(ERR "SET <chave> <valor> - Syntax error")
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["GET", key] = _args) do
    case DatabaseMap.get(key) do
      {:ok, value} -> ~s(#{value})
      {:error, :not_found} -> ~s(NIL)
    end
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["GET" | _] = _args) do
    ~s(ERR "GET <chave> - Syntax error")
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["BEGIN"] = _args) do
    {:ok, deep} = DatabaseMap.start_transaction()
    ~s(#{deep})
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["BEGIN" | _] = _args) do
    ~s(ERR "BEGIN - Syntax error")
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["COMMIT"] = _args) do
    {:ok, deep} = DatabaseMap.commit_transaction()
    ~s(#{deep})
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["COMMIT" | _] = _args) do
    ~s(ERR "COMMIT - Syntax error")
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["ROLLBACK"] = _args) do
    case DatabaseMap.rollback() do
      {:ok, deep} -> ~s(#{deep})
      {:error, _} -> ~s(ERR: "Not possible to rollback in this level of transaction")
    end 
  end

  @spec command([String.t() | integer | boolean | nil]) :: String.t()
  def command(["ROLLBACK" | _] = _args) do
    ~s(ERR "ROLLBACK - Syntax error")
  end

  @spec command([String.t]) :: any
  def command([str_command | _rest]), do: ~s(ERR: "No command #{str_command}")
end
