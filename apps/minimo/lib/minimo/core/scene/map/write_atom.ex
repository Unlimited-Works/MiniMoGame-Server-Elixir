defmodule Minimo.Core.Map.WriteAtom do

  @doc """
  地图数据中的写操作需要做ABA的行为，为了保证程序的一致性
  """

  use GenServer

  # gen server

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # client api

  def new do
    {:ok, pid} = DynamicSupervisor.start_child(WriteAtomMapDynamicSupervisor, __MODULE__)

  end

  def update(server, table_obj, obj_id, f) do
    GenServer.call(server, {:update, {table_obj, obj_id, f}})
  end

  def delete(server) do
    #    Process.exit(pid("0.186.0"), :normal)
    Process.exit(server, :normal)
  end


  # callback

  def init(:ok) do
    {:ok, []}
  end


  def handle_call({:update, {table_map, obj_id, f}}, _from, state) do
    map = :ets.lookup(table_map, obj_id)
    :ets.update_element(table_map, obj_id, {2, apply(f, [map])})
  end

end
