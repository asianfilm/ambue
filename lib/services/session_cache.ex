defmodule Services.SessionCache do
  use GenServer

  @name :cache_server

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @impl GenServer
  def init(_) do
    :ets.new(@name, [:ordered_set, :protected, :named_table])
    {:ok, %{}}
  end

  def get(key) do
    case :ets.lookup(@name, key) do
      [{^key, value} | _] ->
        {:ok, value}

      _ ->
        {:error, :not_found}
    end
  end

  def set(key, value) do
    GenServer.cast(@name, {:set, key, value})
  end

  # CALLBACKS

  @impl GenServer
  def handle_cast({:set, key, value}, state) do
    :ets.insert(@name, {key, value})

    {:noreply, state}
  end
end
