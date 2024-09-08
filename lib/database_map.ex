defmodule DatabaseMap do
  use GenServer

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec init(nil) :: {:ok, %{}}
  def init(nil) do
    {:ok, %{}}
  end

  @spec handle_call({:get, String.t}, any, map()) :: {:reply, any, map()}
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @spec handle_call({:set, String.t, any}, any, map()) :: {:reply, any, map()}
  def handle_call({:put, key, value}, _from, state) do
    {:reply, :ok, Map.put(state, key, value)}
  end

  @spec get(String.t) :: {:ok, any}, {:error, :not_found}
  def get(key) do
    result = GenServer.call(__MODULE__, {:get, key})
    case result do
      nil -> {:error, :not_found}
      _ -> {:ok, result}
    end
  end

  @spec put(String.t, any) :: {:ok, :new} | {:ok, :existing}
  def put(key, value) do
    existing_value = case get(key) do
       {:ok, _any} -> true
       {:error, :not_found} -> false        
    end

    GenServer.call(__MODULE__, {:put, key, value})
   
    if existing_value do
      {:ok, :existing}
    else
      {:ok, :new}
    end
  end
end
