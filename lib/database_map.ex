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

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key, value) do
    GenServer.call(__MODULE__, {:put, key, value})
  end
end
