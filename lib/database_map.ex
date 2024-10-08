defmodule DatabaseMap do
  use GenServer

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    {:ok, [%{}, %{}]}
  end

  def handle_call({:get, key}, _from, state) do
    current_transaction = search_key(Enum.reverse(state), key)

    {:reply, Map.get(current_transaction, key), state}
  end

  def handle_call({:set, key, value}, _from, state) do
    reversed_state = Enum.reverse(state)
    [head | tail] = reversed_state
    new_state = [Map.put(head, key, value) | tail]
      
    {:reply, :ok, Enum.reverse(new_state)}
  end

  def handle_call({:start_transaction}, _from, state) do
    {:reply, {:ok, length(state) - 1}, state ++ [%{}]}
  end

  def handle_call({:commit_transaction}, _from, [db, state]) do
    new_state = [Map.merge(db, state), %{}]

    {:reply, {:ok, 0}, new_state}
  end

  def handle_call({:commit_transaction}, _from, state) do
    [head | tail] = Enum.reverse(state)
    [new_head | new_tail] = tail
    new_state = [Map.merge(new_head, head) | new_tail]

    {:reply, {:ok, max(length(new_state) - 2, 0)}, Enum.reverse(new_state)}
  end

  def handle_call({:rollback}, _from, [db, state]) do
    {:reply, {:error, 0}, [db, state]}
  end

  def handle_call({:rollback}, _from, state) do
    [_head | tail] = Enum.reverse(state)
    {:reply, {:ok, max(length(tail) - 2, 0)}, Enum.reverse(tail)}
  end

  @spec search_key([map], String.t) :: map
  def search_key([], _key), do: %{}
  def search_key([head | tail], key) do
    if Map.has_key?(head, key) do
      head
    else
      search_key(tail, key)
    end
  end

  @spec get(String.t) :: {:ok, any}, {:error, :not_found}
  def get(key) do
    result = GenServer.call(__MODULE__, {:get, key})
    case result do
      nil -> {:error, :not_found}
      _ -> {:ok, result}
    end
  end

  @spec set(String.t, any) :: {:ok, :new} | {:ok, :existing}
  def set(key, value) do
    existing_value = case get(key) do
       {:ok, _any} -> true
       {:error, :not_found} -> false        
    end

    GenServer.call(__MODULE__, {:set, key, value})
   
    if existing_value do
      {:ok, :existing}
    else
      {:ok, :new}
    end
  end

  @spec start_transaction() :: {:ok, integer}
  def start_transaction do
    GenServer.call(__MODULE__, {:start_transaction})
  end

  @spec commit_transaction() :: {:ok, integer}
  def commit_transaction do
    GenServer.call(__MODULE__, {:commit_transaction})
  end

  @spec rollback() :: {:ok, integer}
  def rollback do
    GenServer.call(__MODULE__, {:rollback})
  end
end
