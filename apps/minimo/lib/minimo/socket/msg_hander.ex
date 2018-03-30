defmodule Minimo.Socket.MsgHander do
  use GenServer
  
  def start_link(_) do
    IO.puts("#{__MODULE__}.start_link begin")
    rst = GenServer.start_link(__MODULE__, nil, [])
    IO.puts("#{__MODULE__}.start_link end")
    rst
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:square_root, x}, _from, state) do
    IO.puts("process #{inspect(self())} calculating square root of #{x}")
    :timer.sleep(1000)
    {:reply, :math.sqrt(x), state}
  end

  def handle_call({:request, load_map}, _from, state) do
    IO.puts("process #{inspect(self())} handle request - ")
    IO.inspect(load_map)
    module_name = Minimo.Router.Routee.get_module(load_map["path"])
    map_result = module_name.apply(load_map["protoId"], load_map["load"])
    
    {:reply, map_result, state}
  end
  
end
