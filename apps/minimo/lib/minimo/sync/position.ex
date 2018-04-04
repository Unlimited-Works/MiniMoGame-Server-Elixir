defmodule Minimo.Sync.Position do
  use GenServer

  @doc """
  every second update 15~30 times to every object
  """

  
  ## Client API
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def delete(str_obj_id) do
    GenServer.cast(__MODULE__, {:delete, str_obj_id})
  end
  
  def lookup(str_obj_id) do
    case :ets.lookup(__MODULE__, str_obj_id) do
      [{^str_obj_id, tup3_pos}] -> {:ok, tup3_pos}
      [] -> :error
    end
    
  end

  def set_pos(str_obj_id, tup3_pos) do
    GenServer.cast(__MODULE__, {:set, {str_obj_id, tup3_pos}})
  end
  
  ## Server callbacks
  
  def init(:ok) do
    table_pos = :ets.new(__MODULE__, [:named_table, read_concurrency: true])
    {:ok, table_pos}
  end

  def handle_cast({:set, {str_obj_id, tup3_pos}}, table_pos) do
    :ets.insert(table_pos, {str_obj_id, tup3_pos})
    {:noreply, table_pos}
  end

  def handle_cast({:delete, str_obj_id}, table_pos) do
    :ets.delete(table_pos, str_obj_id)
    {:noreply, table_pos}
  end

end

