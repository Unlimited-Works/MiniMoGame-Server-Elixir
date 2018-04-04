defmodule Minimo.Socket.MsgHander do
  use GenServer
  
  def start_link(_) do
#    IO.puts("#{__MODULE__}.start_link begin")
    rst = GenServer.start_link(__MODULE__, nil, [])
#    IO.puts("#{__MODULE__}.start_link end")
    rst
  end

  def init(_) do
    {:ok, nil}
  end

#  def handle_call({:square_root, x}, _from, state) do
#    IO.puts("process #{inspect(self())} calculating square root of #{x}")
#    :timer.sleep(1000)
#    {:reply, :math.sqrt(x), state}
#  end

  def handle_call({:request, map_load, map_context}, _from, state) do
    IO.puts("process #{inspect(self())} handle request - map_load: #{inspect(map_load)}, map_context: #{inspect(map_context)}")
    
    module_name = Minimo.Router.Routee.get_module(map_load["path"])
    map_result = module_name.apply(map_load["protoId"], map_load["load"])
    
    {:reply, map_result, state}
  end
  
end
